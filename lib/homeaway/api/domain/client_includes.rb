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

require 'homeaway/api/domain/listing'
require 'homeaway/api/domain/listing_reviews'
require 'homeaway/api/domain/listing_review'
require 'homeaway/api/domain/search'
require 'homeaway/api/domain/quote'
require 'homeaway/api/domain/my_listings'
require 'homeaway/api/domain/my_inbox'
require 'homeaway/api/domain/submit_review'
require 'homeaway/api/domain/me'
require 'homeaway/api/domain/my_reservations'
require 'homeaway/api/domain/add_message'
require 'homeaway/api/domain/conversation'

module HomeAway
  module API
    class Client
      include HomeAway::API::Domain::Listing
      include HomeAway::API::Domain::ListingReviews
      include HomeAway::API::Domain::ListingReview
      include HomeAway::API::Domain::Search
      include HomeAway::API::Domain::Quote
      include HomeAway::API::Domain::MyListings
      include HomeAway::API::Domain::MyInbox
      include HomeAway::API::Domain::SubmitReview
      include HomeAway::API::Domain::Me
      include HomeAway::API::Domain::MyReservations
      include HomeAway::API::Domain::AddMessage
      include HomeAway::API::Domain::Conversation
    end
  end
end