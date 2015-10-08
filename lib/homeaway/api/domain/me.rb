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
      module Me

        # Returns information about the logged in user.
        #
        # analogous to calling a GET on API url /public/me
        #
        # @note user must be logged in via 3 legged oauth to call this function without error
        #
        #
        # @return [HomeAway::API::Response] the result of the call to the API
        def me
          get '/public/me', {}
        end
      end
    end
  end
end