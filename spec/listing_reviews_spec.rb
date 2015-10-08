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
      @client.listing_reviews 100000, 386884
      (1..10).each do |page_number|
        [5, 10, 15, 20, 25].each do |page_size|
          @client.listing_reviews 100000, 386884, :page_number => page_number, :page_size => page_size
        end
      end
    }.to_not raise_error
  end

  it 'can use the paginator' do
    expect {
      paginator = @client.listing_reviews 100000, 386884
      expect(paginator).to be_an_instance_of HomeAway::API::Paginator
      expect(paginator.size).to_not be_nil
    }.to_not raise_error
  end

  it 'can auto paginate' do
    expect {
      pre_test_auto = @client.configuration.auto_paginate
      @client.configure do |c|
        c.auto_pagination = true
      end
      paginator = @client.listing_reviews 100000, 386884
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

end