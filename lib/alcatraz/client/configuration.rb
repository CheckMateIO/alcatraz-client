module Alcatraz
  module Client
    module Configuration
      VALID_OPTIONS = [ :public_key, :secret_key, :api_url ]
      DEFAULT_API_URL = "https://alcatraz.checkmate.io"

      attr_accessor *VALID_OPTIONS

      def self.extended(base)
        base.reset
      end

      def reset
        self.api_url = DEFAULT_API_URL
      end

      def configure
        yield self
      end

      def options
        Hash[ * VALID_OPTIONS.map { |key| [key, send(key)] }.flatten ]
      end
    end
  end
end
