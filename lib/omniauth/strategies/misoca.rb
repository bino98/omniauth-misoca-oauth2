require 'oauth2'
require 'omniauth'
require 'securerandom'
require 'socket'       # for SocketError
require 'timeout'      # for Timeout::Error

module OmniAuth
  module Strategies
    class Misoca < OmniAuth::Strategies::OAuth2
      include OmniAuth::Strategy

      def self.inherited(subclass)
        OmniAuth::Strategy.included(subclass)
      end

      option :name, 'misoca_oauth2'
      option :client_options, {
        :site => 'https://app.misoca.jp',
        :authorize_url => '/oauth2/authorize',
        :token_url => '/oauth2/token'
      }
      option :dev_mode, false

      def client
        options.client_options.site = 'https://dev.misoca.jp' if options.dev_mode
        ::OAuth2::Client.new(options.client_id, options.client_secret, deep_symbolize(options.client_options))
      end

      uid { raw_info['user_id'] }

      info { email: row_info['email'] }

      def raw_info
        info_me_url = 'https://app.misoca.jp/api/v1/me'
        info_me_url = 'https://dev.misoca.jp/api/v1/me' if options.dev_mode
        @raw_info ||= access_token.get(info_me_url).parsed
      end
    end
  end
end

OmniAuth.config.add_camelization 'misoca_oauth2', 'Misoca_Oauth2'
