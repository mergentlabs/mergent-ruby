# frozen_string_literal: true

RSpec.describe Mergent do
  it "has a version number" do
    expect(Mergent::VERSION).not_to be nil
  end

  describe ".api_key=" do
    it "sets the config's API key" do
      described_class.api_key = nil

      expect do
        described_class.api_key = "abcd1234"
      end.to change(described_class, :api_key).from(nil).to("abcd1234")
    end
  end
end
