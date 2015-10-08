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
      module SubmitReview

        # Creates a review for the given listing and unit. The review submitted must go through the standard HomeAway
        # review process and may not appear immediately within the list of reviews for the listing. It is recommended
        # that the link to submitting a review be placed off of the details page of the listing and unit in question.
        #
        # analogous to calling a POST on API url /public/submitReview
        #
        # @note user must be logged in via 3 legged oauth to call this function without error
        #
        # @param headline	[String] A short summary about the stay.
        # @param body	[String] The body of the review.
        # @param locale [String] The locale that the review was written in.
        # @param arrival_date [String, DateTime] The date of arrival for the stay. Can either be a date-parsable string or a DateTime object
        # @param rating [Integer] An overall rating for the stay between 1 and 5.
        # @param listing_id [String] A listing id as supplied by this public API.
        # @param unit_id [String] The unit id within the listing that the review is for.
        # @return [Boolean] true if the review was successfully posted to the moderation queue
        def submit_review(headline, body, locale, arrival_date, rating, listing_id, unit_id, opts={})
          body = {
              'headline' => headline.to_s,
              'body' => body.to_s,
              'locale' => locale.to_s,
              'arrivalDate' => HomeAway::API::Util::Validators.date(arrival_date),
              'rating' => HomeAway::API::Util::Validators.integer(rating, 0, 6),
              'listingId' => listing_id.to_s,
              'unitId' => unit_id.to_s
          }.merge(HomeAway::API::Util::Validators.query_keys(opts))
          begin
            post '/public/submitReview', body
            true
          rescue => e
            raise e
          end
        end
      end
    end
  end
end