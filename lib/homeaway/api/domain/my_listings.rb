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
      module MyListings

        # Returns a paginated summary of the owner's listings.
        #
        # analogous to calling a GET on API url /public/myListings
        #
        # @note user must be logged in via 3 legged oauth to call this function without error
        #
        # Headers:
        # * X-HomeAway-DisplayLocale: If a locale is not specified in a query param, it will be searched for in the X-HomeAway-DisplayLocale Header. If it is not supplied in either area the default locale of the user will be selected if it exists. Otherwise the Accept-Language Header will be used.
        #
        # @option opts [String] :filter_product_type Filter result by the subscription type of the listing: sub|ppb
        # @option opts [String] :filter_status Filter result by the enabled status of the listing: ENABLED|DISABLED
        # @option opts [String] :address_contains Filter results by a word contained in the address
        # @option opts [String] :sort_by Sort (format [field:ASC|DESC,field:ASC|DESC,...]) result by one or more of the following: status|updated|firstLive|subscriptionEnd|subscriptionStart|tierCode|productType
        # @option opts [Integer] :page The page of the listing set.
        # @option opts [Integer] :page_size The size of the page to return
        # @return [HomeAway::API::Paginator] the result of the call to the API
        def my_listings(opts={})
          params = {
              'page' => 1,
              'pageSize' => @configuration.page_size
          }.merge(HomeAway::API::Util::Validators.query_keys(opts))
          hashie = get '/public/myListings', params
          HomeAway::API::Paginator.new(self, hashie, @configuration.auto_pagination)
        end
      end
    end
  end
end