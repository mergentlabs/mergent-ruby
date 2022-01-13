# frozen_string_literal: true

module Mergent
  class Object
    attr_reader :_data

    def initialize(data = {})
      @_data = data.transform_keys(&:to_sym)
    end
  end
end
