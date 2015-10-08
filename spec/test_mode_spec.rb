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

describe 'test mode', :vcr do

  before :each do
    @client = authd_client
  end

  it 'can get me in test mode' do
    expect {
      @client.configuration[:test_mode] = true
      response = @client.me
      expect(response._metadata.headers.has_key?('x-homeaway-testmode')).to be_truthy
      expect(response._metadata.headers['x-homeaway-testmode']).to be_truthy
    }.to_not raise_error
  end
end