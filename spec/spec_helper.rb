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

require 'rspec'
require 'vcr'
require 'simplecov'
require 'cgi'
require 'uri'
require 'mechanize'
require 'openssl'
require 'homeaway_api'

SimpleCov.start do
  add_filter '/spec/'
end

SimpleCov.command_name 'test:units'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def json_pg(hash)
  require 'timeout'
  begin
    Timeout::timeout(3) do
      JSON.pretty_generate hash
    end
  rescue
    MultiJson.dump(hash)
  end
end

module VCR
  class Cassette
    class Serializers
      module JSON
        def serialize(hash)
          handle_encoding_errors do
            json_pg hash
          end
        end
      end
    end
  end
end


VCR.configure do |c|
  c.cassette_library_dir = 'cassettes/'
  c.hook_into :webmock
  c.default_cassette_options = {record: :all,
                                serialize_with: :json,
                                preserve_exact_body_bytes: true
  }
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = true
end

def client_id
  raise NotImplementedError.new 'must supply a client id'
end

def client_secret
  raise NotImplementedError.new 'must supply a client secret'
end

def test_email
  raise NotImplementedError.new 'must supply a valid user email'
end

def test_password
  raise NotImplementedError.new 'must supply a valid user password'
end

if File.exists? 'internal/spec_helper_extensions.rb'
  require_relative '../internal/spec_helper_extensions.rb'
end

def scaffolded_client
  client = HomeAway::API::Client.new(
      client_id: client_id,
      client_secret: client_secret,
      connection_opts: {
          ssl: {
              verify: true
          }
      },
      site: 'https://ws.homeaway.com',
  )
  client
end

def get_code
  agent = Mechanize.new
  #default to logging in as an owner with the following url
  auth_url = "https://cas.homeaway.com/auth/homeaway/login?service=https%3A%2F%2Fws.homeaway.com%2Foauth%2Fowner%2Fj_spring_cas_security_check%3Fspring-security-redirect%3Dhttps%253A%252F%252Fws.homeaway.com%252Foauth%252Fowner%252FauthorizeOwner%253Fclient_id%253D#{client_id}%2526"
  agent.get(auth_url) do |login_page|
    login_page.form_with(:id => 'login-form') do |form|
      form.username = test_email
      form.password = test_password
    end.submit

    agent.follow_redirect = false
    agent.get("https://cas.homeaway.com/auth/homeaway/login?service=https://ws.homeaway.com/oauth/authenticate?clientId=#{client_id}") do |page|
      unless page.response['location']
        raise 'Login failed. Please check the email and password provided'
      end
      return CGI.parse(URI.parse(page.response['location']).query)['ticket'].first
    end
  end
end

class ClientCache
  require 'singleton'
  include Singleton

  attr_accessor :client
end

def authd_client
  cache = ClientCache.instance
  client = cache.client
  if client.nil? || client.token_expired?
    client = scaffolded_client
    code = get_code
    client.oauth_code = code
    cache.client = client
  end
  client
end
