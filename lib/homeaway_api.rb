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

require 'homeaway/api/version'
require 'hashie'
require 'base64'
require 'logger'
require 'rest-client'
require 'openssl'
require 'chronic'
require 'active_support/all'

require 'homeaway/api/errors/ha_api_errors'
require 'homeaway/api/util/validators'
require 'homeaway/api/util/defaults'
require 'homeaway/api/util/oauth'
require 'homeaway/api/paginator'
require 'homeaway/api/response'
require 'homeaway/api/client'
require 'homeaway/api/adapters/faraday'
require 'homeaway/api/adapters/hurley'

require 'homeaway/api/domain/client_includes'

module HomeAway
  # The official HomeAway API Ruby SDK
  # @author Charlie Meyer <cmeyer@homeaway.com>
  module API

  end
end