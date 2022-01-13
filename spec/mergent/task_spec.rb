# frozen_string_literal: true

RSpec.describe Mergent::Task do
  describe "delegated methods" do
    described_class::ATTRS.each do |method_name|
      it "defines a method for #{method_name}" do
        expect(described_class.new({ method_name => :foo }).public_send(method_name)).to(eq(:foo))
      end
    end
  end

  describe "#create" do
    it "creates and returns a Task with the specified params" do
      Mergent.api_key = "abcd1234"

      params = { request: { url: "https://example.com" } }
      stub = stub_request(:post, "https://api.mergent.co/v1/tasks")
             .with(
               headers: {
                 Authorization: "Bearer #{Mergent.api_key}",
                 "Content-Type": "application/json"
               },
               body: params.to_json
             )
             .to_return(body: { name: "taskname" }.to_json)

      task = described_class.create(params)

      expect(stub).to have_been_made
      expect(task).to be_a described_class
      expect(task.name).to eq "taskname"
    end
  end
end
