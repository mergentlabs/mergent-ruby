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
    before do
      Mergent.api_key = "abcd1234"
    end

    let!(:stub) do
      stub_request(:post, "#{Mergent.endpoint}/tasks")
        .with(
          headers: {
            Authorization: "Bearer #{Mergent.api_key}",
            "Content-Type": "application/json"
          },
          body: expected_body
        )
        .to_return(body: { id: "3ffd61d6-b10e-45d5-b266-e998aea71e8b", queue: queue }.to_json)
    end

    context "when queue is passed" do
      let(:params) { { queue: queue, request: { url: "https://example.com" } } }
      let(:queue) { "foobar" }

      let(:expected_body) { params.to_json }

      it "creates and returns a Task with the specified params" do
        task = described_class.create(params)

        expect(stub).to have_been_made
        expect(task).to be_a described_class
        expect(task.queue).to eq queue
      end
    end

    context "when :queue is not passed" do
      let(:params) { { request: { url: "https://example.com" } } }

      let(:expected_body) { { queue: queue }.merge(params).to_json }
      let(:queue) { "default" }

      it "uses the default queue name" do
        task = described_class.create(params)

        expect(stub).to have_been_made
        expect(task).to be_a described_class
        expect(task.queue).to eq "default"
      end
    end
  end
end
