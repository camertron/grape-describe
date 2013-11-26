# encoding: UTF-8

$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'grape/grape-describe/version'

Gem::Specification.new do |s|
  s.name     = "grape-describe"
  s.version  = ::Grape::GrapeDescribe::VERSION
  s.authors  = ["Cameron Dutro"]
  s.email    = ["cdutro@twitter.com"]
  s.homepage = ""

  s.description = s.summary = "Provides a json endpoint that outputs a description of your Grape APIs."

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true

  s.require_path = 'lib'

  s.files = Dir["{lib,spec}/**/*", "Gemfile", "History.txt", "LICENSE", "README.md", "Rakefile", "grape-describe.gemspec"]
end
