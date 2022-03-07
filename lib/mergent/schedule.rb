# frozen_string_literal: true

require_relative "client"
require_relative "object"

module Mergent
  class Schedule < Mergent::Object
    ATTRS = %i[id queue cron rrule dtstart type description request created_at].freeze

    ATTRS.each do |name|
      define_method(name) do
        @_data[name]
      end
    end

    def self.create(params = {})
      data = Client.post(
        "schedules",
        { queue: Mergent::Object::DEFAULT_QUEUE }.merge(params)
      )
      new(data)
    end
  end
end
