# frozen_string_literal: true

RSpec.describe Mergent::RequestValidator do
  subject(:validator) { described_class.new("12345") }

  describe "#build_signature_for" do
    it "builds a HMAC-SHA1 signature for the provided body" do
      body = "foo"

      signature = validator.build_signature_for(body)

      expect(signature).to(eq("QjZpKdTK/iwkUWiz3seoPbJHA0I="))
    end

    context "with nil params" do
      it "is valid" do
        signature = validator.build_signature_for(nil)
        expect(signature).to(eq("KT7FsM8VSFUliCTsf6xdxj0XaRU="))
      end
    end
  end

  describe "#valid_signature?" do
    it "returns true when the signature is valid" do
      signature = validator.build_signature_for(nil)
      expect(validator.valid_signature?(nil, signature)).to(eq(true))
    end

    it "returns false when the signature is invalid" do
      expect(validator.valid_signature?(nil, "invalidsignature")).to(eq(false))
    end
  end
end
