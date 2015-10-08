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

describe 'HomeAway API client configuration' do

  before :each do
    @client = HomeAway::API::Client.new client_id: client_id, client_secret: client_secret
  end

  it 'configures defaults properly' do
    defaults = HomeAway::API::Util::Defaults.instance
    expect(@client.configuration.site).to eql defaults.site
    expect(@client.configuration.port).to eql defaults.port
    expect(@client.configuration.auth_url).to eql defaults.auth_url
    expect(@client.configuration.token_url).to eql defaults.token_url
  end

  it 'will raise an error if client_id and client_secret are not present' do
    expect {
      @client.configure do |c|
        c.delete :client_id
        c.delete :client_secret
      end
    }.to raise_error ArgumentError
  end

  it 'will raise an error if the client_secret is missing' do
    expect {
      @client.configure do |c|
        c.delete :client_secret
        c.client_id = client_id
      end
    }.to raise_error ArgumentError
  end

  it 'will raise an error if the client_id is missing' do
    expect {
      @client.configure do |c|
        c.delete :client_id
        c.client_secret = client_secret
      end
    }.to raise_error ArgumentError
  end

  it 'will not raise an error both the client_id and secret are supplied' do
    expect {
      @client.configure do |c|
        c.client_id = client_id
        c.client_secret = client_secret
      end
    }.to_not raise_error
    expect(@client.configuration.client_id).to eql client_id
    expect(@client.configuration.client_secret).to eql client_secret
  end

  it 'should raise an error if an invalid uuid is given as the client id or secret' do
    expect {
      HomeAway::API::Client.new 'foo', 'bar'
    }.to raise_error ArgumentError
    expect {
      HomeAway::API::Client.new client_id, 'bar'
    }.to raise_error ArgumentError
    expect {
      HomeAway::API::Client.new 'foo', client_secret
    }.to raise_error ArgumentError
  end

  it 'should have frozen defaults' do
    expect(HomeAway::API::Util::Defaults.instance.frozen?).to be_truthy
  end
end