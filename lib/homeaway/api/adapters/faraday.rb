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

require 'faraday'
require 'faraday-http-cache'
require 'faraday_middleware/response/follow_redirects'
require 'faraday_middleware/instrumentation'
require 'faraday_middleware/response/mashify'
require 'faraday_middleware/response/parse_json'

module HomeAway
  module API
    # @private
    module Adapters
      # @private
      class FaradayAdapter
        # @private
        def self.call(site, opts, headers, method, uri, body, params)
          agent = Faraday::Connection.new(site, opts) do |conn|
            conn.headers = headers
            conn.adapter Faraday.default_adapter
            conn.options.params_encoder = Faraday::FlatParamsEncoder
            conn.use Faraday::HttpCache
            conn.use FaradayMiddleware::Mashify, :mash_class => HomeAway::API::Response
            conn.use FaradayMiddleware::ParseJson
            conn.use FaradayMiddleware::Instrumentation
            conn.use FaradayMiddleware::FollowRedirects
          end
          response = agent.send(method, uri) do |req|
            req.body = body.to_json unless body.empty?
            req.params = params unless params.empty?
          end
          self.transform response
        end

        # @private
        def self.transform(response)
          mash = response.body
          mash = HomeAway::API::Response.new unless mash
          mash._metadata.headers = HomeAway::API::Response.new(response.headers.to_hash) if response.respond_to? :headers
          if response.respond_to? :status
            mash._metadata.status_code = response.status
            if mash._metadata.status_code.to_i >= 400
              raise (HomeAway::API::Errors.for_http_code mash._metadata.status_code).new(mash)
            end
          end
          if response.respond_to? :env
            mash._metadata.request_headers = HomeAway::API::Response.new(response.env.request_headers.to_hash) if response.env.respond_to? :request_headers
          end
          mash
        end
      end
    end
  end
end