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

describe 'submit review', :vcr do

  before :each do
    @client = authd_client
  end

  # NOTE: run this test carefully, we don't want to submit reviews in prod
  it 'throws weird json errors when we submit a review with nil or empty headline' do
    # skip 'not running this in production because we do not want to create invalid data'
    expect {
      @client.submit_review '', 'some nonsense', 'en_US', '03/08/2015', 5, 100000, 386884
    }.to raise_error HomeAway::API::Errors::BadRequestError
  end

  it 'allows me to submit a review' do
    expect {
      @client.submit_review 'test headline', 'some nonsense', 'en_US', '03/08/2015', 5, 100000, 386884
    }.to_not raise_error
  end

end