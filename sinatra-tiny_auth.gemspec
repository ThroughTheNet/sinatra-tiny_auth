# -*- encoding: utf-8 -*-
require File.expand_path("../lib/sinatra/tiny_auth/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "sinatra-tiny_auth"
  s.version     = Sinatra::TinyAuth::VERSION
  s.platform    = Gem::Platform::RUBY

  s.required_rubygems_version = ">= 1.3.6"
  s.summary = 'Single user authentication for sinatra'

  s.add_runtime_dependency 'sinatra', '~> 1.0'
  s.add_runtime_dependency 'haml', '~> 3.0'
  s.add_runtime_dependency 'activesupport', '>= 2.3'
  s.add_runtime_dependency 'bcrypt-ruby', '>0'
  s.add_runtime_dependency 'thor', '>0'
  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency 'rspec', '~> 2'
  s.add_development_dependency 'rack-test', '>0'
  s.add_development_dependency 'awesome_print', '>0'
  s.add_development_dependency 'fuubar', '>0'

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end

