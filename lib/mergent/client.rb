# frozen_string_literal: true

require "net/http"
require "json"

module Mergent
  class Client
    def self.post(resource, params) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      uri = URI("https://api.mergent.co/v1/#{resource}")
      headers = {
        Authorization: "Bearer #{Mergent.api_key}",
        "Content-Type": "application/json"
      }
      request = Net::HTTP::Post.new(uri, headers)
      request.body = params.to_json

      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      response = https.request(request)

      case response
      when Net::HTTPSuccess
        JSON.parse(response.read_body, object_class: Mergent::Object)
      else
        begin
          body = JSON.parse(response.read_body)
        rescue JSON::ParserError
          body = {}
        end
        raise Mergent::Error, body["message"]
      end
    rescue EOFError, Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::EHOSTUNREACH, Errno::ETIMEDOUT, SocketError
      raise Mergent::ConnectionError
    end
  end
end
