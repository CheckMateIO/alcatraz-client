require 'faraday_middleware'

module Alcatraz
  module Client
    class Connection
      attr_accessor *Configuration::VALID_OPTIONS

      def initialize(options = {})
        merged_options = ::Alcatraz::Client.options.merge(options)

        Configuration::VALID_OPTIONS.each do |key|
          public_send("#{key}=", merged_options[key])
        end
      end

      def get_card(id)
        parse_response_to_secure_object(get("/cards/#{id}"))
      end

      def store_card!(params)
        parse_response_to_secure_object(post('/cards', params))
      end

      def get_data(id)
        parse_response_to_secure_object(get("/secure_data/#{id}"))
      end

      def store_data!(params)
        parse_response_to_secure_object(post('/secure_data', params))
      end

      def create_client!(name, enable_two_factor_auth = false)
        response = post('/api_clients', api_client: {name: name, enable_two_factor_auth: enable_two_factor_auth})
        if response.success?
          response.body.api_client
        else
          nil
        end
      end

      def destroy_client!(id)
        delete("/api_clients/#{id}")
      end

      def enable_two_factor_auth!(id)
        response = put("/api_clients/#{id}/enable_two_factor_auth")
        if response.success?
          response.body.api_client
        else
          nil
        end
      end

      def disable_two_factor_auth!(id)
        response = put("/api_clients/#{id}/disable_two_factor_auth")
        if response.success?
          response.body.api_client
        else
          nil
        end
      end

      def authorize_data_for_client!(data_or_id, client_or_public_key)
        data_id = unwrap_to_id data_or_id
        public_key = unwrap_to_key client_or_public_key
        post("/secure_data/#{data_id}/authorizations", public_key: public_key).success?
      end

      def deauthorize_data_for_client!(data_or_id, client_or_public_key)
        data_id = unwrap_to_id data_or_id
        public_key = unwrap_to_key client_or_public_key
        delete("/secure_data/#{data_id}/authorizations/#{public_key}")
      end

      private

      def unwrap_to_id(object_or_id)
        object_or_id = object_or_id.id unless object_or_id.kind_of?(String)
        object_or_id
      end

      def unwrap_to_key(object_or_key)
        object_or_key = object_or_key.public_key unless object_or_key.kind_of?(String)
        object_or_key
      end

      def connection
        Faraday.new(url: api_url) do |conn|
          conn.request :json
          conn.use Faraday::Request::Hmac, secret_key, nonce: (Time.now.to_f * 1e6).to_i.to_s, query_based: true, extra_auth_params: {public_key: public_key}
          conn.use Faraday::Response::Mashify
          conn.response :json, content_type: /\bjson$/
          conn.adapter Faraday.default_adapter
        end
      end

      def get(path, options = {})
        connection.get(path, options)
      end

      def post(path, options = {})
        connection.post(path, options)
      end

      def put(path, options = {})
        connection.put(path, options)
      end

      def delete(path)
        response = connection.delete(path)
        response.success?
      end

      def parse_response_to_secure_object(response)
        if response.success?
          if response.body.respond_to? :card
            response.body.card
          elsif response.body.respond_to? :secure_datum
            response.body.secure_datum
          else
            response.body
          end
        else
          nil
        end
      end
    end
  end
end
