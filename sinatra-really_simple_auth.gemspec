# -*- encoding: utf-8 -*-
require File.expand_path("../lib/sinatra/really_simple_auth/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "sinatra-really_simple_auth"
  s.version     = Sinatra::ReallySimpleAuth::VERSION
  s.platform    = Gem::Platform::RUBY

  s.required_rubygems_version = ">= 1.3.6"

  s.add_runtime_dependency 'sinatra', '~> 1.0'
  s.add_runtime_dependency 'haml', '~> 3.0'
  s.add_runtime_dependency 'activesupport', '>= 2.3'
  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency 'shoulda', '~> 2.0'

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end

