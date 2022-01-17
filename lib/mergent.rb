# frozen_string_literal: true

require_relative "mergent/errors"
require_relative "mergent/task"
require_relative "mergent/version"

module Mergent
  ENDPOINT = "https://api.mergent.co/v1"

  class << self
    attr_accessor :api_key, :endpoint
  end
end

Mergent.endpoint = Mergent::ENDPOINT
