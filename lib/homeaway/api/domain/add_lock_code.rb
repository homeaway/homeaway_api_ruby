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
      module AddLockCode

        # Add a Lock Access Code to an existing Reservation
        #
        # analogous to calling a POST on API url /public/addLockCode
        #
        # @param listing_id [String] The affected listing ID
        # @param reservation_refnum [String] The affected reservation's reference number
        # @param lock_code [String] Lock Access Code as a string of digits
        # @param provider [String] Name of entity providing lock codes
        # @param access_instructions [String] (optional)
        # @return [HomeAway::API::Response] the result of the call to the API
        def add_lock_code(listing_id, reservation_refnum, lock_code, provider, access_instructions = '', opts={})
          body = {
              'listingId' => listing_id,
              'reservationReferenceNumber' => reservation_refnum,
              'lockCode' => lock_code,
              'provider' => provider,
              'accessInstructions' => access_instructions
          }.merge(HomeAway::API::Util::Validators.query_keys(opts))
          post '/public/addLockCode', body
        end
      end
    end
  end
end
