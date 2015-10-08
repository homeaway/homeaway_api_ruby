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
      module MyInbox

        # Load the Owner's Inbox for the logged-in User
        #
        # analogous to calling a GET on API url /public/myInbox
        #
        # @note user must be logged in via 3 legged oauth to call this function without error
        #
        # Headers:
        # * X-HomeAway-DisplayLocale: If a locale is not specified in a query param, it will be searched for in the X-HomeAway-DisplayLocale Header. If it is not supplied in either area the default locale of the user will be selected if it exists. Otherwise the Accept-Language Header will be used.
        #
        # @option opts [String] :status The conversation status by which to filter the inbox. The supported values for this param are: BLOCKED_RESERVATION, BOOKING, CANCELLED, INQUIRY, PAYMENT_REQUEST_SENT, POST_STAY, QUOTE_SENT, REPLIED, RESERVATION, RESERVATION_DOWNLOADABLE, RESERVATION_REQUEST, RESERVATION_REQUEST_DECLINED, RESERVATION_REQUEST_EXPIRED, STAYING, TENTATIVE_RESERVATION, UNKNOWN, RECALCULATE
        # @option opts [Boolean] :unreplied_only A flag indicating that the inbox should be populated by only unreplied conversations
        # @option opts [String] :sort The field by which to Sort Conversations.
        # @option opts [DateTime or Date parsible string] :before_date Conversations will not be included in the results unless they had some activity on or before this date. Use yyyy-MM-dd as the format
        # @option opts [Boolean] :archived A flag indicating that the inbox should be populated by only archived conversations
        # @option opts [String] :search A string to search for.
        # @option opts [Boolean] :inquiries A flag indicating the inbox should be populated by only inquiries
        # @option opts [Boolean] :sort_reservation_requests_inline If True, in the default Inbox view, sort Reservation Requests inline rather than at the top.
        # @option opts [Boolean] :reservations A flag indicating the inbox should be populated by only reservations
        # @option opts [String] :sort_order The order to sort by, ASC or DESC.
        # @option opts [Boolean] :unread_only A flag indicating that the inbox should be populated by only unread conversations
        # @option opts [DateTime or Date parsible string] :after_date Conversations will not be included in the results unless they had some activity on or after this date. Use yyyy-MM-dd as the format
        # @option opts [Integer] :page The page of the result set
        # @option opts [Integer] :page_size The size of a page of results
        # @option opts [Boolean] :as_traveler set this to true if you are attempting to get a traveler's inbox, defaults to false which will retrieve an owner's inbox
        # @return [HomeAway::API::Paginator] the result of the call to the API
        def my_inbox(opts={})
          params = {
              'page' => 1,
              'pageSize' => @configuration.page_size,
              'asTraveler' => false
          }.merge(HomeAway::API::Util::Validators.query_keys(opts))
          hashie = get '/public/myInbox', params
          HomeAway::API::Paginator.new(self, hashie, @configuration.auto_pagination)
        end
      end
    end
  end
end