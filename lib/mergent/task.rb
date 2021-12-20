# frozen_string_literal: true

require_relative "client"
require_relative "object"

module Mergent
  class Task < Mergent::Object
    def self.create(params = {})
      object = Client.post("tasks", params)
      new(object)
    end

    %i[name description status request scheduled_for delay cron].each do |name|
      define_method(name) do
        self[name]
      end
    end
  end
end
