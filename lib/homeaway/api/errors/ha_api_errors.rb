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

module HomeAway
  module API
    # a collection of error classes corresponding to various errors that might be raised by the HomeAway API
    module Errors

      # @private
      class HomeAwayAPIError < StandardError

        attr_reader :response

        # @private
        def initialize(response=nil)
          @response = response
        end

        # @private
        def to_s
          begin
            buf = "#{self.class.name} #{@response._metadata.status_code} "
            @response.violations.each do |violation|
              buf << "#{violation.description} | "
            end
            buf = buf[0..-3] unless @response.violations.empty?
            return buf
          rescue
            if @response.nil?
              super
            else
              @response.to_s
            end
          end
        end

        # @private
        def self.method_missing(name, *args, &block)
          if @response.respond_to? name
            @response.send name
          else
            super
          end
        end
      end

      # raised when the token a client is using has become expired
      class TokenExpiredError < StandardError
      end

      # @private
      class ClientError < HomeAwayAPIError
      end

      # represents a HTTP 400
      class BadRequestError < ClientError
        CODE = 400
      end

      # represents a HTTP 500
      class InternalServerError < HomeAwayAPIError
        CODE = 500
      end

      # represents a HTTP 404
      class ResourceNotFoundError < ClientError
        CODE = 404
      end

      # represents a HTTP 401
      class UnauthorizedError < ClientError
        CODE = 401
      end

      # represents a HTTP 403
      class ForbiddenError < ClientError
        CODE = 403
      end

      # represents a HTTP 405
      class MethodNotAllowedError < ClientError
        CODE = 405
      end

      # represents a HTTP 416
      class RequestedRangeNotSatisfiableError < ClientError
        CODE = 416
      end

      # represents a HTTP 429. This will be raised when a client exceeds their rate limit
      class TooManyRequestsError < ClientError
        CODE = 429
      end

      # represents a HTTP 503
      class APINotAvailableError < HomeAwayAPIError
        CODE = 503
      end

      # represents a HTTP 406
      class NotAcceptableError < ClientError
        CODE = 406
      end

      # represents a HTTP 409
      class ConflictError < ClientError
        CODE = 409
      end

      # @private
      class ImATeapotError < ClientError
        #hopefully this is never ever used
        CODE = 418
      end

      # @private
      def self.for_http_code(status_code)
        begin
          self.const_get(self.constants.select do |c|
            const = self.const_get c
            Class === const &&
                const.const_defined?(:CODE) &&
                const.const_get(:CODE) == status_code.to_i
          end.first)
        rescue => _
          HomeAwayAPIError
        end
      end

    end
  end
end