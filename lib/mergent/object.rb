# frozen_string_literal: true

module Mergent
  class Object
    def initialize(data = {})
      @_data = data.transform_keys(&:to_sym)
    end

    def [](key)
      @_data[key.to_sym]
    end

    def []=(key, value)
      @_data[key.to_sym] = value
    end

    def method_missing(name, *args)
      return super unless @_data.key?(name)

      @_data[name]
    end

    def respond_to_missing?(name, include_private = false)
      @_data.key?(name) || super
    end
  end
end
