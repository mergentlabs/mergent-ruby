# frozen_string_literal: true

require "net/http"
require "json"

module Mergent
  class Client
    def self.post(resource, params)
      request(Net::HTTP::Post, resource, params)
    end

    def self.delete(resource, params)
      request(Net::HTTP::Delete, resource, params)
    end

    private

    def self.request(request_class, resource, params) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      uri = URI("#{Mergent.endpoint}/#{resource}")
      headers = {
        Authorization: "Bearer #{Mergent.api_key}",
        "Content-Type": "application/json"
      }
      request = request_class.new(uri, headers)
      request.body = params.to_json

      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = Mergent.endpoint.start_with?("https")
      response = https.request(request)
      response_body = response.read_body || "{}"

      case response
      when Net::HTTPSuccess
        JSON.parse(response_body)
      else
        begin
          body = JSON.parse(response_body)
        rescue JSON::ParserError
          body = {}
        end
        raise Mergent::Error, error_message(body)
      end
    rescue EOFError, Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::EHOSTUNREACH, Errno::ETIMEDOUT, SocketError
      raise Mergent::ConnectionError
    end
    private_class_method :request

    def self.error_message(body)
      breakdown = body.fetch("errors", []).map { |error| error.fetch("message", nil) }.compact.join(", ")
      msg = body["message"]
      msg << " - #{breakdown}" unless breakdown.empty?
      msg
    end
    private_class_method :error_message
  end
end
