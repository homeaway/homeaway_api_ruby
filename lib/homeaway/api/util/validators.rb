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

require 'cgi'

module HomeAway
  module API
    module Util

      # @private
      module Validators

        # @private
        def self.uri_encoded(input)
          CGI.escape input
        end

        # @private
        def self.date(input)
          if input.is_a? String
            input = Chronic.parse(input, :ambiguous_time_range => :none)
          end
          raise ArgumentError.new('dates must be a parseable date string or a Ruby Time object') unless input.is_a? Time
          input.to_date.to_s
        end

        # @private
        def self.float(input, min=nil, max=nil)
          begin
            input_s = input.to_s
            !!Float(input_s)
            f = input_s.to_f
            unless min == nil
              raise ArgumentError.new("Supplied argument #{f} must be greater than #{min}") if f < min
            end
            unless max == nil
              raise ArgumentError.new("Supplied argument #{f} must be less than #{max}") if f > max
            end
            return f
          rescue
            raise ArgumentError.new("Supplied argument #{input} must be a valid float value")
          end
        end

        # @private
        def self.integer(input, min=nil, max=nil)
          begin
            input_s = input.to_s
            !!Integer(input_s)
            i = input_s.to_i
            unless min == nil
              raise ArgumentError.new("Supplied argument #{i} must be greater than #{min}") if i < min
            end
            unless max == nil
              raise ArgumentError.new("Supplied argument #{i} must be less than #{max}") if i > max
            end
            return i
          rescue
            raise ArgumentError.new("Supplied argument #{input} must be a valid integer value")
          end
        end

        # @private
        def self.boolean(input)
          input_s = input.to_s
          return true if input_s =~ (/^(true)$/i)
          return false if input_s.empty? || input_s =~ (/^(false)$/i)
          raise ArgumentError.new("Supplied argument #{input} must be a valid boolean value")
        end

        # @private
        def self.camel_case(input)
          input.to_s.camelize(:lower)
        end

        # @private
        def self.snake_case(input)
          input.to_s.underscore
        end

        # @private
        def self.query_keys(hash)
          raise ArgumentError.new('arguments must be a hash') unless hash.is_a? Hash
          transformed = {}
          hash.each_key do |key|
            transformed[self.camel_case(key)] = hash[key]
          end
          transformed
        end

        # @private
        def self.uuid(input)
          uuid_regex = /\A([0-9a-fA-F]{32}|[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})\z/
          raise ArgumentError.new("#{uuid.to_s} must be a valid uuid") unless input.to_s =~ uuid_regex
          input.to_s
        end

        # @private
        def self.array(input)
          return nil if input == nil
          [input].flatten
        end
      end
    end
  end
end