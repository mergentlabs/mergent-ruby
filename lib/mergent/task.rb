# frozen_string_literal: true

require_relative "client"
require_relative "object"

module Mergent
  class Task < Mergent::Object
    ATTRS = %i[name description status request scheduled_for created_at].freeze

    ATTRS.each do |name|
      define_method(name) do
        @_data[name]
      end
    end

    def self.create(params = {})
      data = Client.post("tasks", params)
      new(data)
    end
  end
end
