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
      module Conversation

        # Load Conversation content, including Messages, for a selected Conversation
        #
        # analogous to calling a GET on API url /public/conversation
        #
        # @note user must be logged in via 3 legged oauth to call this function without error
        #
        # Headers:
        # * X-HomeAway-DisplayLocale: If a locale is not specified in a query param, it will be searched for in the X-HomeAway-DisplayLocale Header. If it is not supplied in either area the default locale of the user will be selected if it exists. Otherwise the Accept-Language Header will be used.
        #
        # @param id [String] The Conversation UUID to load.
        # @return [HomeAway::API::Response] the result of the call to the API
        def conversation(id)
          params = {'id' => HomeAway::API::Util::Validators.uuid(id)}
          get '/public/conversation', HomeAway::API::Util::Validators.query_keys(params)
        end
      end
    end
  end
end