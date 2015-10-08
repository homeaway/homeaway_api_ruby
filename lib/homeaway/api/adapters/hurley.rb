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

require 'hurley'
require 'cgi'

# @private
module Hurley
  # @private
  class Query
    # @private
    def self.default
      @default ||= Flat
    end
  end
end


module HomeAway
  module API
    # @private
    module Adapters
      # @private
      class HurleyAdapter
        # @private
        def self.__update_opts(struct, opts)
          opts.each_pair do |k, v|
            method = "#{k}=".to_sym
            if struct.respond_to?(method)
              struct.send(method, v)
            end
          end
        end

        # @private
        def self.call(site, opts, headers, method, uri, body, params)
          begin
            agent = Hurley::Client.new(site)
            agent.header.update(headers)
            self.__update_opts(agent.request_options, opts)
            self.__update_opts(agent.ssl_options, opts)
            request = agent.request(method, uri)
            request.query.update(params) unless params.empty?
            request.body = body.to_json unless (!body.respond_to?(:to_json) || body.empty?)
            response = agent.call(request)
          rescue => e
            raise HomeAway::API::Errors::HomeAwayAPIError.new(e.message.to_s)
          end
          response_to_mash(response)
        end

        # @private
        def self.response_to_mash(response)
          body = response.body ||= {}
          mash = HomeAway::API::Response.new
          mash.update JSON.parse(body) unless body.empty?
          mash._metadata = HomeAway::API::Response.new
          mash._metadata.headers = response.header.to_hash if response.respond_to? :header
          if response.respond_to? :status_code
            mash._metadata.status_code = response.status_code
            if mash._metadata.status_code.to_i >= 400
              raise (HomeAway::API::Errors.for_http_code mash._metadata.status_code).new(mash)
            end
          end
          mash.delete(:_metadata) if mash._metadata.empty?
          mash
        end
      end
    end
  end
end