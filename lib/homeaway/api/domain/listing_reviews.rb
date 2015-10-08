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
    module Domain
      module ListingReviews

        # Returns a page of reviews for the specified listing and unit
        #
        # analogous to calling a GET on API url /public/listingReviews
        #
        # @param listing_id [String] The listing id to be booked as retrieved from the search operation
        # @param unit_id [Integer] The id of the unit being booked for the stay
        # @option opts [Integer] :page The page number to fetch
        # @option opts [Integer] :page_size The number of reviews to return per page
        # @return [HomeAway::API::Paginator] the result of the call to the API
        def listing_reviews(listing_id, unit_id, opts={})
          params = {
              'listingId' => listing_id.to_s,
              'unitId' => unit_id.to_s,
              'page' => 1,
              'pageSize' => @configuration.page_size
          }.merge(HomeAway::API::Util::Validators.query_keys(opts))
          hashie = get '/public/listingReviews', params
          HomeAway::API::Paginator.new(self, hashie, @configuration.auto_pagination)
        end
      end
    end
  end
end