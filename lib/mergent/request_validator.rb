# frozen_string_literal: true

module Mergent
  class RequestValidator
    def initialize(api_key)
      @api_key = api_key || Mergent.api_key
    end

    def build_signature_for(url, body)
      data = (url || "") + (body || "")
      digest = OpenSSL::Digest.new("sha1")
      Base64.strict_encode64(OpenSSL::HMAC.digest(digest, @api_key, data))
    end

    def valid_signature?(url, body, signature)
      build_signature_for(url, body) == signature
    end
  end
end
