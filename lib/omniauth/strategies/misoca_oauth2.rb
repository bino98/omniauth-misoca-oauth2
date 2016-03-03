require 'oauth2'
require 'omniauth'
require 'securerandom'
require 'socket'       # for SocketError
require 'timeout'      # for Timeout::Error

module OmniAuth
  module Strategies
    class MisocaOauth2 < OmniAuth::Strategies::OAuth2
      include OmniAuth::Strategy

      DEVELOPMENT_API_URL = 'https://dev.misoca.jp'
      PRODUCTION_API_URL  = 'https://app.misoca.jp'

      DEFAULT_SCOPE       = 'read'

      def self.inherited(subclass)
        OmniAuth::Strategy.included(subclass)
      end

      option :name, 'misoca_oauth2'
      option :client_options, {
        :site => PRODUCTION_API_URL,
        :authorize_url => '/oauth2/authorize',
        :token_url => '/oauth2/token'
      }
      option :authorize_options, [:scope]

      option :dev_mode, false

      def client
        options.client_options.site = DEVELOPMENT_API_URL if options.dev_mode
        ::OAuth2::Client.new(options.client_id, options.client_secret, deep_symbolize(options.client_options))
      end

      uid { raw_info['user_id'] }

      info do
        prune!({
          email: row_info['email']
        })
      end

      def authorize_params
        super.tap do |params|
          options[:authorize_options].each do |k|
            params[k] = request.params[k.to_s] unless [nil, ''].include?(request.params[k.to_s])
          end
          raw_scope = params[:scope] || DEFAULT_SCOPE
        end
      end

      def raw_info
        info_endpoint = '/api/v1/me'
        info_me_url = PRODUCTION_API_URL  + info_endpoint
        info_me_url = DEVELOPMENT_API_URL + info_endpoint if options.dev_mode
        @raw_info ||= access_token.get(info_me_url).parsed
      end

      protected
      def prune!(hash)
        hash.delete_if do |_, v|
          prune!(v) if v.is_a?(Hash)
          v.nil? || (v.respond_to?(:empty?) && v.empty?)
        end
      end
    end
  end
end

OmniAuth.config.add_camelization 'misoca_oauth2', 'MisocaOauth2'
