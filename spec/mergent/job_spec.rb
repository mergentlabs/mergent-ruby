# frozen_string_literal: true

RSpec.describe Mergent::Job do
  before do
    Mergent.api_key = "abcd1234"
  end

  describe "delegated methods" do
    described_class::ATTRS.each do |method_name|
      it "defines a method for #{method_name}" do
        expect(described_class.new({ method_name => :foo }).public_send(method_name)).to(eq(:foo))
      end
    end
  end

  describe ".create" do
    before do
      Mergent.api_key = "abcd1234"
    end

    let!(:stub) do
      stub_request(:post, "#{Mergent.endpoint}/jobs")
        .with(
          headers: {
            Authorization: "Bearer #{Mergent.api_key}",
            "Content-Type": "application/json"
          },
          body: expected_body
        )
        .to_return(body: { id: "3ffd61d6-b10e-45d5-b266-e998aea71e8b", queue: queue }.to_json, status: 201)
    end

    context "when :queue is passed" do
      let(:params) { { queue: queue, request: { url: "https://example.com" } } }
      let(:queue) { "foobar" }

      let(:expected_body) { params.to_json }

      it "creates and returns a Job with the specified params" do
        job = described_class.create(params)

        expect(stub).to have_been_made
        expect(job).to be_a described_class
        expect(job.queue).to eq queue
      end
    end

    context "when :queue is not passed" do
      let(:params) { { request: { url: "https://example.com" } } }

      let(:expected_body) { { queue: queue }.merge(params).to_json }
      let(:queue) { "default" }

      it "uses the default queue name" do
        job = described_class.create(params)

        expect(stub).to have_been_made
        expect(job).to be_a described_class
        expect(job.queue).to eq "default"
      end
    end
  end

  describe ".update" do
    let!(:stub) do
      stub_request(:patch, "#{Mergent.endpoint}/jobs/#{id}")
        .with(
          headers: {
            Authorization: "Bearer #{Mergent.api_key}",
            "Content-Type": "application/json"
          },
          body: updates.to_json
        )
        .to_return(body: { id: "12345", **updates }.to_json)
    end

    let(:id) { "1234567890" }
    let(:updates) { { name: "My updated name" } }

    it "sends the request" do
      described_class.update(id, updates)

      expect(stub).to have_been_made
    end

    it "returns the updated Job" do
      job = described_class.update(id, updates)

      expect(job.name).to(eq("My updated name"))
    end
  end

  describe ".delete" do
    let!(:stub) do
      stub_request(:delete, "#{Mergent.endpoint}/jobs/#{id}")
        .with(
          headers: {
            Authorization: "Bearer #{Mergent.api_key}",
            "Content-Type": "application/json"
          }
        )
        .to_return(body: nil, status: 204)
    end

    let(:id) { "1234567890" }

    it "sends the request" do
      described_class.delete(id)

      expect(stub).to have_been_made
    end

    it "returns true" do
      expect(described_class.delete(id)).to(be(true))
    end
  end
end
