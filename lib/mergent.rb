# frozen_string_literal: true

require_relative "mergent/errors"
require_relative "mergent/task"
require_relative "mergent/version"

module Mergent
  class << self
    attr_accessor :api_key
  end
end
