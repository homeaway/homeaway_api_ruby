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
    class Client

      # @return [Hash] the global default configuration
      def self.default_configuration
        @@default_configuration ||= HomeAway::API::Util::Defaults.instance.to_hash
      end

      # Pass a block expecting a single hash parameter and set any global configuration settings
      # that will be inherited by all instances created in the future
      # @return [Hash] the global default configuration
      def self.configure
        yield @@default_configuration if block_given?
        @@default_configuration
      end

      include HomeAway::API::Util::OAuth

      attr_accessor :configuration
      attr_reader :mode, :token, :token_expires, :refresh_token

      # @!attribute [rw] configuration
      #   @return [Hash] the current client configuration

      # @!attribute [r] token
      #   @return [String] the current encoded token this client has

      # @!attribute [r] mode
      #   @return [Symbol] the current authentication state of this client. One of either :unauthorized, :two_legged, or :three_legged

      # @!attribute [r] token_expires
      #   @return [Time] the time that the current token in use on this client will expire


      # Instantiates a new HomeAway API client
      #
      # @option opts [String] :client_id Your HomeAway API OAuth client id. Required here if not set globally
      # @option opts [String] :client_secret Your HomeAway API OAuth client secret. Required here if not set globally
      # @option opts [String] :refresh_token An existing token if you already have one saved from a previous usage of the api
      # @return [HomeAway::API::Client] a newly instantiated HomeAway API client
      def initialize(opts={})
        @configuration = Hashie::Mash.new(self.class.default_configuration.merge(opts))
        if opts.has_key?(:refresh_token)
          @configuration[:manual_token_supplied] = true
          @refresh_token = opts.delete(:refresh_token)
          refresh
        end
        validate_configuration
        logger.debug("client initialized with configuration: #{@configuration}")
        attempt_auth if @token.nil?
      end

      # Update the configuration of this particular instance of the client.
      # Pass a block expecting a single hash parameter to update the configuration settings.
      # @return [Hash] This client's configuration
      def configure
        yield @configuration if block_given?
        validate_configuration
        @configuration
      end

      # @return [Object] The current logger that has been configured
      def logger
        @configuration.logger
      end

      # @return [String] The current bearer auth token
      def token
        raise HomeAway::API::Errors::HomeAwayAPIError.new('Ticket must be supplied') if @token.nil?
        @token
      end

      # @return [String] The current refresh token
      def refresh_token
        @refresh_token
      end

      # @private
      def marshal_dump
        # we lose our logger instance naively here, marshal dump doesn't like
        # one of its fields
        dump_config = configuration.dup.to_hash
        dump_config.delete('logger')
        [@token, token_expires, dump_config]
      end

      # @private
      def marshal_load(array)
        @token = array[0]
        @token_expires = array[1]
        @configuration = Hashie::Mash.new(array[2])
        @configuration.logger = HomeAway::API::Util::Defaults.instance.logger
      end

      # @return [Boolean] Has the token that the client is currently using expired?
      def token_expired?
        return false if @configuration[:manual_token_supplied]
        begin
          Time.now >= token_expires
        rescue
          true
        end
      end

      # @private
      def get(url, params={})
        method :get, url, {}, params
      end

      # @private
      def put(url, body, params={})
        method :put, url, body, params
      end

      # @private
      def post(url, body, params={})
        method :post, url, body, params
      end

      # @private
      def delete(url, params={})
        method :delete, url, {}, params
      end

      # @private
      def options(url, params={})
        method :options, url, {}, params
      end

      private

      def validate_configuration
        required_uuids = [:client_id, :client_secret]
        [required_uuids].flatten.each do |required_configuration_directive|
          raise ArgumentError.new("#{required_configuration_directive.to_s} is required but not supplied") if (@configuration[required_configuration_directive] == nil || @configuration[required_configuration_directive].nil? || !configuration.has_key?(required_configuration_directive))
        end
        required_uuids.each do |uuid|
          HomeAway::API::Util::Validators.uuid(@configuration[uuid])
        end
        true
      end


      def adapter
        registered_adapters = {
            :faraday => HomeAway::API::Adapters::FaradayAdapter,
            :hurley => HomeAway::API::Adapters::HurleyAdapter
        }
        raise ArgumentError.new("Invalid adapter #{@configuration[:adapter]}") unless registered_adapters.keys.include? @configuration[:adapter]
        logger.debug("using adapter: #{@configuration[:adapter]}")
        registered_adapters[@configuration[:adapter]]
      end

      def headers
        headers = {}
        headers['content-type'] = 'application/json'
        headers['Cache-control'] = @configuration[:cache_control]
        headers['Authorization'] = "Bearer #{token}"
        headers['User-Agent'] = "HomeAway API ruby_sdk/#{HomeAway::API::VERSION}"
        headers['X-HomeAway-RequestMarker'] = SecureRandom.uuid
        headers['X-HomeAway-TestMode'] = 'true' if @configuration[:test_mode]
        logger.debug("Sending headers: #{headers.to_json}")
        headers
      end

      def method(method, url, body, params)
        if token_expired?
          if @configuration[:auto_reauth]
            logger.info('Token expired and auth_reauth is enabled, attempting 2 legged oauth.')
            attempt_auth
            logger.info("Re-authentication attempt completed. Current client status: #{@mode}")
          else
            raise HomeAway::API::Errors::TokenExpiredError.new('token is expired, please login again via the oauth url')
          end
        end
        logger.info("#{method.to_s.upcase} to #{url} with params #{params.to_json}")
        site = @configuration[:api_site] ||= @configuration[:site]
        response = adapter.call(site, @configuration[:connection_opts], headers, method, url, body, params)
        logger.debug("returning payload: #{response.to_json}")
        response
      end

      def attempt_auth
        begin
          two_legged!
          @mode = :two_legged
        rescue => e
          logger.info("failed to perform automatic 2 legged oauth due to: #{e.to_s}")
          @mode = :unauthorized
        end
      end

    end
  end
end

require 'homeaway/api/domain/client_includes'