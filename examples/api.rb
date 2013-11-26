# encoding: UTF-8

require 'grape'
require 'grape/grape_describe'

class Api < Grape::API
  params do
    requires :hello, {
      :type => String,
      :desc => "world",
      :default => "hola"
    }

    optional :foo, {
      :type => Integer,
      :desc => "bar"
    }
  end

  desc "This endpoint is really cool"
  set(:name, "something")

  get "path/to/something" do
    { :result => "blarg", :format => params[:format] }
  end

  params do
    requires :twitter, {
      :desc => "is cool"
    }
  end

  desc "Whassup"
  set(:name, "something_else")

  get "path/to/something_else" do
    { :result => "blarg 2", :format => params[:format] }
  end

  describe_endpoints({
    :path => "describe"
  })
end