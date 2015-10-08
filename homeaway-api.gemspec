# Copyright (c) 2015 HomeAway.com, Inc.
# All rights reserved.  http://www.homeaway.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'homeaway/api/version'

Gem::Specification.new do |spec|
  spec.name = 'homeaway-api'
  spec.version = HomeAway::API::VERSION
  spec.authors = ['Charlie Meyer']
  spec.email = %w(cmeyer@homeaway.com)
  spec.summary = %q{Ruby SDK for interacting with the HomeAway API}
  spec.description = %q{Ruby SDK for interacting with the HomeAway API}
  spec.homepage = 'http://www.homeaway.com/platform/'
  spec.license = 'Apache 2.0'

  spec.files = %w(Gemfile LICENSE.txt Rakefile README.md)
  spec.files += Dir.glob("lib/**/*.rb")
  spec.executables = ['hacurl']
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'hashie'
  spec.add_runtime_dependency 'rest-client'
  spec.add_runtime_dependency 'chronic'
  spec.add_runtime_dependency 'faraday'
  spec.add_runtime_dependency 'hurley'
  spec.add_runtime_dependency 'faraday_middleware'
  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'json_color'
  spec.add_runtime_dependency 'mechanize'
  spec.add_runtime_dependency 'faraday-http-cache'
  spec.add_runtime_dependency 'oauth2'


  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.1.0'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'json'
  spec.add_development_dependency 'multi_json'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'multi_xml'


end
