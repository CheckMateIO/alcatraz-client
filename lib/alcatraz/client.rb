require 'faraday/request/hmac'
require 'alcatraz/client/version'
require 'alcatraz/client/configuration'
require 'alcatraz/client/connection'

module Alcatraz
  module Client
    extend Configuration
    class << self
      def new(options = {})
        Alcatraz::Client::Connection.new(options)
      end
    end
  end
end
