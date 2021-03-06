# frozen_string_literal: true

RSpec.describe Mergent::Schedule do
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

  describe "#create" do
    before do
      Mergent.api_key = "abcd1234"
    end

    let!(:stub) do
      stub_request(:post, "#{Mergent.endpoint}/schedules")
        .with(
          headers: {
            Authorization: "Bearer #{Mergent.api_key}",
            "Content-Type": "application/json"
          },
          body: expected_body
        )
        .to_return(body: { id: "3ffd61d6-b10e-45d5-b266-e998aea71e8b", queue: queue }.to_json)
    end

    context "when :queue is passed" do
      let(:params) { { queue: queue, request: { url: "https://example.com" } } }
      let(:queue) { "foobar" }

      let(:expected_body) { params.to_json }

      it "creates and returns a Schedule with the specified params" do
        schedule = described_class.create(params)

        expect(stub).to have_been_made
        expect(schedule).to be_a described_class
        expect(schedule.queue).to eq queue
      end
    end

    context "when :queue is not passed" do
      let(:params) { { request: { url: "https://example.com" } } }

      let(:expected_body) { { queue: queue }.merge(params).to_json }
      let(:queue) { "default" }

      it "uses the default queue name" do
        schedule = described_class.create(params)

        expect(stub).to have_been_made
        expect(schedule).to be_a described_class
        expect(schedule.queue).to eq "default"
      end
    end
  end

  describe "#delete" do
    let!(:stub) do
      stub_request(:delete, "#{Mergent.endpoint}/schedules/#{id}")
        .with(
          headers: {
            Authorization: "Bearer #{Mergent.api_key}",
            "Content-Type": "application/json"
          }
        )
        .to_return(body: nil)
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

  describe "#update" do
    let!(:stub) do
      stub_request(:patch, "#{Mergent.endpoint}/schedules/#{id}")
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
    let(:updates) { { description: "My updated description" } }

    it "sends the request" do
      described_class.update(id, updates)

      expect(stub).to have_been_made
    end

    it "returns the updated Schedule" do
      schedule = described_class.update(id, updates)

      expect(schedule.description).to(eq("My updated description"))
    end
  end
end
