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
      module Quote

        # Generates an up to date quote and booking url
        #
        # analogous to calling a GET on API url /public/bookStay
        #
        # Headers:
        # * X-HomeAway-DisplayLocale: If a locale is not specified in a query param, it will be searched for in the X-HomeAway-DisplayLocale Header. If it is not supplied in either area the default locale of the user will be selected if it exists. Otherwise the Accept-Language Header will be used.
        #
        # @param listing_id [String] The listing id to be booked as retrieved from the search operation
        # @param unit_id [String] The id of the unit being booked for the stay
        # @param adults_count [Integer] The number of adults being booked for the stay
        # @param departure_date [String] The departure date in the form yyyy-MM-dd
        # @param arrival_date [String] The arrival date in the form yyyy-MM-dd
        # @option opts [String] :currency_code The currency to generate the quote in (optional defaults to USD)
        # @option opts [Boolean] :pet_included Optional boolean indicating that a pet will accompany the guests
        # @option opts [Integer] :children_count The optional number of children being booked for the stay
        # @return [HomeAway::API::Response] the result of the call to the API
        def quote(listing_id, unit_id, adults_count, arrival_date, departure_date, opts={})
          params = {
              'listingId' => listing_id.to_s,
              'unitId' => unit_id.to_s,
              'departureDate' => HomeAway::API::Util::Validators.date(departure_date),
              'adultsCount' => HomeAway::API::Util::Validators.integer(adults_count),
              'arrivalDate' => HomeAway::API::Util::Validators.date(arrival_date),
              'locale' => 'en'
          }.merge(HomeAway::API::Util::Validators.query_keys(opts))
          get '/public/quote', params
        end

        alias_method :book_stay, :quote
      end
    end
  end
end