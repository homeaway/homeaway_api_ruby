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
      module Listing

        # Given a listing id, return details about the listing.
        #
        # analogous to calling a GET on API url /public/listing
        #
        # Headers:
        # * X-HomeAway-DisplayLocale: If a locale is not specified in a query param, it will be searched for in the X-HomeAway-DisplayLocale Header. If it is not supplied in either area the default locale of the user will be selected if it exists. Otherwise the Accept-Language Header will be used.
        #
        # @param id [String] The id of the listing.
        # @option opts [String] :q Use the q parameter to fetch specific listing details. Valid options are AVAILABILITY, DETAILS, LOCATIONS, PHOTOS, RATES, REVIEWS. If no value is given, the listing is returned with minimal content. Can be an array of multiple values.
        # @option opts [String] :l Use the l parameter to specify the locale. For example: 'fr'
        # @return [HomeAway::API::Response] the result of the call to the API
        def listing(id, q=nil, l=nil)
          params = {'id' => id.to_s}
          params['locale'] = l unless l == nil
          params['q'] = HomeAway::API::Util::Validators.array(q) unless q == nil
          get '/public/listing', HomeAway::API::Util::Validators.query_keys(params)
        end
      end
    end
  end
end