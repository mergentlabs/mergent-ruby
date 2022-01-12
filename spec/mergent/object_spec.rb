# frozen_string_literal: true

RSpec.describe Mergent::Object do
  describe ".initialize" do
    it "initializes an Object with the provided data" do
      object = described_class.new({ foo: :bar })

      expect(object.foo).to eq :bar
    end

    it "symbolizes the keys" do
      object = described_class.new({ "foo" => :bar })

      expect(object.foo).to eq :bar
    end
  end

  describe "#[]" do
    it "allows fields to be retreived using hash notation" do
      object = described_class.new({ foo: :bar })

      expect(object[:foo]).to eq :bar
      expect(object["foo"]).to eq :bar
    end
  end

  describe "#[]=" do
    it "allows fields to be set using hash notation" do
      object = described_class.new
      object[:foo] = :bar

      expect(object[:foo]).to eq :bar
      expect(object["foo"]).to eq :bar
    end
  end

  describe "#method_missing" do
    it "allows fields to be retreived using method notation" do
      object = described_class.new({ foo: :bar })

      expect(object.foo).to eq :bar
    end
  end

  describe "#respond_to?" do
    it "returns true when the method exists" do
      object = described_class.new
      object[:foo] = :bar

      expect(object.respond_to?(:foo)).to be true
    end

    it "returns false when the method does not exist" do
      object = described_class.new

      expect(object.respond_to?(:foo)).to be false
    end
  end
end
