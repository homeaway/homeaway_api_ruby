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
      module Search

        # Search for listings
        #
        # analogous to calling a GET on API url /public/search
        #
        # Headers:
        # * Authenticated: _required_: By specifying a Client object in the method signature, all incoming requests MUST have a valid current OAuth authenticated client
        # * X-HomeAway-DisplayLocale: _required_: If a locale is not specified in a query param, it will be searched for in the X-HomeAway-DisplayLocale Header. If it is not supplied in either area the default locale of the user will be selected if it exists. Otherwise the Accept-Language Header will be used.
        #
        # @option opts [String] :q The query to search for listings with, for example 'austin sleeps 6'
        # @option opts [Integer] :min_bedrooms Minimum number of bedrooms to search (optional)
        # @option opts [Integer] :min_sleeps Minimum number of sleeps to search (optional)
        # @option opts [String] :availability_start Date formatted as yyyy-MM-dd to indicate the earliest available date  (lower bound) in the search (optional)
        # @option opts [Integer] :max_sleeps Maximum number of sleeps to search (optional)
        # @option opts [String] :availability_end Date formatted as yyyy-MM-dd to indicate the latest available date  (upper bound) in the search (optional)
        # @option opts [Integer] :min_bathrooms Minimum number of bathrooms to search (optional)
        # @option opts [Float] :center_point_latitude Uses a proximity search to limit results to listings located within a max distance from a specific location, must be sent with centerPointLongitude and distanceInKm
        # @option opts [String] :refine Refine the search with the given comma delimited refinements (optional comes from a search refinement)
        # @option opts [String] :sort Sort the results <field:asc|desc> where field is one of (availabilityUpdated, bathrooms, bedrooms, prices, travelerReviewCount, averageRating) (optional)
        # @option opts [Float] :upper_right_longitude Adds a geographical bounding box constraint to the search. Only listings located within this bounding box will be returned in the results, must be sent with lowerLeftLongitude, upperRightLatitude and upperRightLongitude
        # @option opts [Float] :distance_in_km Uses a proximity search to limit results to listings located within a max distance from a specific location, must be sent with centerPointLatitude and centerPointLongitude
        # @option opts [Float] :upper_right_latitude Adds a geographical bounding box constraint to the search. Only listings located within this bounding box will be returned in the results, must be sent with lowerLeftLongitude, upperRightLatitude and upperRightLongitude
        # @option opts [Integer] :max_bedrooms Maximum number of bedrooms to search (optional)
        # @option opts [Integer] :max_bathrooms Maximum number of bathrooms to search (optional)
        # @option opts [Float] :center_point_longitude Uses a proximity search to limit results to listings located within a max distance from a specific location, must be sent with centerPointLatitude and distanceInKm
        # @option opts [Float] :min_price Minimum price to search (optional)
        # @option opts [Float] :lower_left_latitude Adds a geographical bounding box constraint to the search. Only listings located within this bounding box will be returned in the results, must be sent with lowerLeftLongitude, upperRightLatitude and upperRightLongitude
        # @option opts [Float] :lower_left_longitude Adds a geographical bounding box constraint to the search. Only listings located within this bounding box will be returned in the results, must be sent with lowerLeftLongitude, upperRightLatitude and upperRightLongitude
        # @option opts [Float] :max_price Maximum price to search (optional)
        # @option opts [String] :image_size Size of the image to return the URL for (optional) must be one of: SMALL, MEDIUM, LARGE
        # @option opts [Integer] :page The page of the result set
        # @option opts [Integer] :page_size The size of a page of results
        # @return [HomeAway::API::Paginator] the result of the call to the API
        def search(opts={})
          encoded_opts = opts.merge(opts) do |_, v|
            if v.is_a? ::String
              HomeAway::API::Util::Validators.uri_encoded(v)
            else
              v
            end
          end
          params = {
              'locale' => 'en',
              'page' => 1,
              'pageSize' => @configuration.page_size
          }.merge(HomeAway::API::Util::Validators.query_keys(encoded_opts))
          params['availabilityStart'] = HomeAway::API::Util::Validators.date(params['availabilityStart']) if params.has_key?('availabilityStart')
          params['availabilityEnd'] = HomeAway::API::Util::Validators.date(params['availabilityEnd']) if params.has_key?('availabilityEnd')
          hashie = get '/public/search', params
          HomeAway::API::Paginator.new(self, hashie, @configuration.auto_pagination)
        end
      end
    end
  end
end