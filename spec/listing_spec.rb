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

describe 'getting listings', :vcr do

  before :each do
    @client = authd_client
  end

  it 'can make a GET call for a listing' do
    expect {
      response = @client.listing '100000'
      expect(response.listingId).to eql '100000'
      expect(response.sourceLocale).to eql 'en'
      expect(response.sourceLocaleName).to eql 'english'
    }.to_not raise_error
  end

  it 'can make a GET for a listing with a query' do
    expect {
      response = @client.listing '100000', 'DETAILS'
      expect(response.listing_id).to eql '100000'
      expect(response.source_locale).to eql 'en'
      expect(response.source_locale_name).to eql 'english'
    }.to_not raise_error
  end

  it 'can make a GET for a listing with 2 queries' do
    expect {
      response = @client.listing '100000', ['DETAILS', 'RATES']
      expect(response.listing_id).to eql '100000'
      expect(response.source_locale).to eql 'en'
      expect(response.source_locale_name).to eql 'english'
    }.to_not raise_error
  end

  it 'accepts locale parameter' do
    expect {
      response = @client.listing '100000', nil, 'fr'
      expect(response.listing_id).to eql '100000'
      expect(response.source_locale).to eql 'en'
      expect(response.source_locale_name).to eql 'anglais'
    }.to_not raise_error
  end

  it 'raises an error when making a GET for a listing with an invalid query' do
    expect {
      response = @client.listing '100000', 'RACKSONRACKSONRACKS'
      expect(response.listingId).to eql '100000'
      expect(response.sourceLocale).to eql 'en'
      expect(response.sourceLocaleName).to eql 'english'
    }.to raise_error(HomeAway::API::Errors::BadRequestError)
  end
end