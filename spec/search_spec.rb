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

describe 'searching', :vcr do

  before :each do
    @client = authd_client
  end

  it 'can make a GET call search for listings' do
    expect {
      response = @client.search q: 'austin sleeps 6'
      expect(response.pageSize).to eql @client.configuration.page_size
      expect(response.page_size).to eql @client.configuration.page_size
      response.next_page
    }.to_not raise_error
  end

  it 'can make a GET call search for listings without a query' do
    expect {
      response = @client.search min_sleeps: 6
      expect(response.pageSize).to eql @client.configuration.page_size
      expect(response.page_size).to eql @client.configuration.page_size
      response.next_page
    }.to_not raise_error
  end

  it 'can make a GET call search for test listings' do
    expect {
      response = @client.search q: 'austin sleeps 6'
      expect(response.pageSize).to eql @client.configuration.page_size
      expect(response.page_size).to eql @client.configuration.page_size
      expect(response.size).to be > 0
    }.to_not raise_error
  end

  it 'can auto paginate' do
    expect {
      pre_test_auto = @client.configuration.auto_paginate
      @client.configure do |c|
        c.auto_pagination = true
      end
      paginator = @client.search(q: 'austin sleeps 6')
      count = 0
      paginator.each do |_|
        count = count + 1
      end
      expect(count).to be > 10
      @client.configure do |c|
        c.auto_pagination = pre_test_auto
      end
    }.to_not raise_error
  end

  it 'can auto paginate twice' do
    expect {
      pre_test_auto = @client.configuration.auto_paginate
      @client.configure do |c|
        c.auto_pagination = true
      end
      paginator = @client.search(q: 'austin sleeps 6')
      count = 0
      paginator.each do |_|
        count = count + 1
      end
      expect(count).to be > 10
      count2 = 0
      paginator.each do |_|
        count2 = count2 + 1
      end
      expect(count2).to be > 10
      expect(count).to eql count2
      @client.configure do |c|
        c.auto_pagination = pre_test_auto
      end
    }.to_not raise_error
  end

  it 'can make a GET call search for listings with a large page size' do
    expect {
      response = @client.search q: 'austin sleeps 6', page_size: 20
      expect(response.pageSize).to eql 20
      expect(response.page_size).to eql 20
      next_page = response.next_page
    }.to_not raise_error
  end

end