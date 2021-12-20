# frozen_string_literal: true

require_relative "client"
require_relative "object"

module Mergent
  class Task < Mergent::Object
    def self.create(params = {})
      object = Client.post("tasks", params)
      new(object)
    end
  end
end
