require 'rest-client'
require 'plissken'

module Paymaya
  module Checkout
    class Checkout
      def initiate(total_amount:, buyer:, items:, redirect_url: nil,
        request_reference_number: nil, metadata: nil)
        payload = {
          total_amount: total_amount,
          buyer: buyer,
          items: items.map(&:to_camelback_keys)
        }
        payload[:redirect_url] = redirect_url unless redirect_url.nil?
        unless request_reference_number.nil?
          payload[:request_reference_number] = request_reference_number
        end
        payload[:metadata] = metadata unless metadata.nil?
        response = RestClient.post(checkout_url, payload.to_camelback_keys.to_json, auth_headers_2)
        JSON.parse(response)
      end

      def checkout_url
        "#{Paymaya.config.base_url}/checkout/v1/checkouts"
      end

      def auth_headers
        {
          authorization:
            "Basic #{Base64.strict_encode64(Paymaya.config.secret_key + ':').chomp}",
          content_type: 'application/json'
        }
      end

      def auth_headers_2
        {
          authorization:
            "Basic #{Base64.strict_encode64(Paymaya.config.public_key + ':').chomp}",
          content_type: 'application/json'
        }
      end

      private :checkout_url, :auth_headers
    end
  end
end