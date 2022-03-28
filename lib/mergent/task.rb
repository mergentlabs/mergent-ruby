# frozen_string_literal: true

require_relative "client"
require_relative "object"

module Mergent
  class Task < Mergent::Object
    ATTRS = %i[id name queue status request scheduled_for created_at].freeze

    ATTRS.each do |name|
      define_method(name) do
        @_data[name]
      end
    end

    def self.create(params = {})
      data = Client.post(
        "tasks",
        { queue: Mergent::Object::DEFAULT_QUEUE }.merge(params)
      )
      new(data)
    end

    def self.update(id, params)
      data = Client.patch("tasks/#{id}", params)
      new(data)
    end

    def self.delete(id)
      Client.delete("tasks/#{id}")
      true
    end
  end
end
