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

describe 'oauth', :vcr do

  before :each do
    @client = scaffolded_client
  end

  it 'has a proper authorize url' do
    expect(@client.auth_url).to include '/oauth/authorize'
  end

  it 'can go with the oauth flow' do
    code = get_code
    expect {
      @client.oauth_code = code
    }.to_not raise_error
    expect(@client.token).to_not be_nil
  end

  it 'can auth with only 2 legs' do
    expect {
      expect(@client.listing('100000')).to_not be_nil
    }.to_not raise_error
  end

  it 'does not let me in if i have invalid credentials' do
    ticket = get_code

    expect {
      client = HomeAway::API::Client.new client_id: '48a7f167-b00c-4c8c-932d-82272aef904c', client_secret: '5f11a415-fc91-4bca-b7fa-61356935d66e'
      client.oauth_code = ticket
    }.to raise_error(HomeAway::API::Errors::UnauthorizedError)
  end

  it 'doesnt let me in if i have an invalid ticket' do
    expect {
      @client.oauth_code = 'invalid_auth_code_here'
    }.to raise_error(HomeAway::API::Errors::UnauthorizedError)
  end

  it 'can properly use refresh tokens' do
    client = authd_client
    refresh_token = client.refresh_token
    new_client = client_from_refresh_token(refresh_token)
    expect {
      me = new_client.me
      expect(me.email_address).to eql test_email
    }.to_not raise_error
  end
end