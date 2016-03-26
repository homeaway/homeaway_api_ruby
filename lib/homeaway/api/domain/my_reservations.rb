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
      module MyReservations

        # Returns a paginated list of the current and future reservations for the given listing from oldest to newest.
        #
        # analogous to calling a GET on API url /public/myReservations
        #
        # @note user must be logged in via 3 legged oauth to call this function without error
        #
        #
        # @param listing_id [String] The listingId of the listing to get the reservations for.
        # @option opts [String] :begin_date Lower bound date of the reservations to find in the format yyyy-MM-dd
        # @option opts [String] :reference_number Reference number to filter on
        # @option opts [String] :end_date Upper bound date of the reservations to find in the format yyyy-MM-dd
        # @option opts [String] :last_name Last name of traveler to filter on
        # @option opts [String] :payment_status PaymentStatus to filter on
        # @option opts [String] :availability_status Status to filter on
        # @option opts [String] :first_name First name of traveler to filter on
        # @option opts [String] :email Email of traveler to filter on
        # @option opts [String] :sort_by Sort (format [field:ASC|DESC,field:ASC|DESC,...]) result by one or more of the following: availabilityStatus|beginDate|paymentStatus
        # @option opts [Integer] :page The page of the listing set.
        # @option opts [Integer] :page_size The size of the page to return
        # @return [HomeAway::API::Paginator] the result of the call to the API
        def my_reservations(listing_id, opts={})
          params = {
              'page' => 1,
              'pageSize' => @configuration.page_size,
              'listingId' => listing_id.to_s
          }.merge(HomeAway::API::Util::Validators.query_keys(opts))
          hashie = get '/public/myReservations', params
          HomeAway::API::Paginator.new(self, hashie, @configuration.auto_pagination)
        end
      end
    end
  end
end