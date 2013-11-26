# encoding: UTF-8

require 'pry-nav'

module Grape
  class API

    DEFAULT_ATTRS = { :required => false }

    class << self

      def generate_describe_endpoints
        endpoint_data = gather_endpoints(endpoints).map do |endpoint|
          endpoint_info(endpoint)
        end

        Class.new(Grape::API) do
          get("describe") do
            endpoint_data
          end
        end
      end

      protected

      def gather_endpoints(endpoints)
        endpoints.flat_map do |endpoint|
          if app = endpoint.options[:app]
            gather_endpoints(app.endpoints)
          else
            [endpoint]
          end
        end
      end

      def endpoint_info(endpoint)
        {
          :method     => endpoint.options[:method].first.downcase,
          :parameters => parameter_info(endpoint.settings.stack.last),
          :path       => endpoint.routes.first.route_path,
          :desc       => endpoint.options[:route_options][:description],
          :name       => endpoint.settings[:name] || ""
        }
      end

      def parameter_info(stack)
        stack = [stack] if stack.is_a?(Hash)
        stack.flat_map do |frame|
          frame[:declared_params].map do |param|
            initial_attrs = DEFAULT_ATTRS.merge(:name => param)
            matching_validations_for(param, stack.first).inject(initial_attrs) do |attrs, validation|
              attrs[:desc] ||= validation.doc_attrs[:desc]
              attrs.merge!(attrs_for(validation))
              attrs
            end
          end
        end
      end

      def matching_validations_for(param, stack)
        stack[:validations].select do |validation|
          validation.attrs.include?(param)
        end
      end

      def attrs_for(validation)
        case validation
          when Grape::Validations::PresenceValidator then presence_attrs_for(validation)
          when Grape::Validations::CoerceValidator   then coerce_attrs_for(validation)
          when Grape::Validations::DefaultValidator  then default_attrs_for(validation)
          else
            {}
        end
      end

      def presence_attrs_for(validation)
        { :required => true }
      end

      def coerce_attrs_for(validation)
        { :type => validation.doc_attrs[:type] }
       end

      def default_attrs_for(validation)
        { :default => validation.instance_variable_get(:'@default') }
      end

    end

  end
end