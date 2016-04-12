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

require 'spec_helper'

describe 'listing reviews', :vcr do


  before :each do
    @client = authd_client
  end

  it 'can get them' do
    expect {
      paginator = @client.listing_reviews 100000, 386884
      review = paginator.entries.first
      uuid = review.review_id
      review = @client.listing_review uuid
      expect(review).to_not be_nil
      expect(review.has? :body).to be_truthy
      expect(review.body).to be_a_kind_of ::String
    }.to_not raise_error
  end
end