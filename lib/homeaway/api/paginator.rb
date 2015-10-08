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
    class Paginator
      include Enumerable

      # @private
      def initialize(client, hashie, auto_pagination=false)
        @hashie = hashie
        @client = client
        @auto_pagination = auto_pagination
      end

      # supply a block that expects a single parameter to iterate through this paginator
      def each(&block)
        if @auto_pagination
          first_hashie = @hashie.clone
          while true
            cur_hits = entries.clone
            cur_hits.each do |entity|
              if block_given?
                block.call entity
              else
                yield entity
              end
            end
            if @hashie.nextPage && @hashie.page < 300
              begin
                next_page!
              rescue HomeAway::API::Errors::RequestedRangeNotSatisfiableError
                # we have a max page limit
                # reset me to the first so that I can be iterated over again
                @hashie = first_hashie
                break
              end
            else
              # reset me to the first so that I can be iterated over again
              @hashie = first_hashie
              break
            end
          end
        else
          entries.each do |entity|
            if block_given?
              block.call entity
            else
              yield entity
            end
          end
        end
      end

      # @return [Integer] the size of this paginator
      def size
        return @hashie['size'] if @hashie.has_key? 'size'
        0
      end

      alias_method :length, :size

      # @return [HomeAway::API::Paginator] a paginator object that has the next page of results
      def next_page
        return nil unless next_page?
        next_hashie = @client.get(*parse_url(nextPage))
        self.class.new(@client, next_hashie, @auto_pagination)
      end

      # updates this paginator to have the next page of results in place
      # @return [Boolean] true if successful
      def next_page!
        return false unless next_page?
        @hashie = @client.get(*parse_url(nextPage))
        true
      end

      # @return [Boolean] does this paginator have another page?
      def next_page?
        @hashie.has_key? 'nextPage'
      end

      # @return [HomeAway::API::Paginator] a paginator object that has the previous page of results
      def previous_page
        return nil unless previous_page?
        prev_hashie = @client.get(*parse_url(prevPage))
        self.class.new(@client, prev_hashie, @auto_pagination)
      end

      # updates this paginator to have the previous page of results in place
      # @return [Boolean] true if successful
      def previous_page!
        return false unless previous_page?
        @hashie = @client.get(*parse_url(prevPage))
        true
      end

      # @return [Boolean] does this paginator have previous page?
      def previous_page?
        @hashie.has_key? 'prevPage'
      end

      # @private
      def method_missing(name, *args, &block)
        if @hashie.respond_to? name
          @hashie.send name, *args, &block
        else
          super
        end
      end

      # @return [Array] the current page of results as an array of entities
      def entries
        entries = @hashie['entries'] ||= nil
        entries.map { |entry| HomeAway::API::Response.new(entry) }
      end

      alias_method :hits, :entries

      private

      def parse_url(input)
        uri = URI.parse(input)
        return uri.path, CGI.parse(uri.query)
      end
    end
  end
end
