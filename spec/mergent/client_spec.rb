# frozen_string_literal: true

RSpec.describe Mergent::Client do
  before do
    Mergent.api_key = "abcd1234"
    Mergent.endpoint = "https://testhost.mergent.co/api"
  end

  shared_examples "a client action" do # rubocop:disable Metrics/BlockLength
    it "makes a request to the specified resource with the specified action, parsing the JSON body into an Object" do
      params = { name: "objectname" }
      stub = stub_request(action, "#{Mergent.endpoint}/objects")
             .with(
               headers: {
                 Authorization: "Bearer #{Mergent.api_key}",
                 "Content-Type": "application/json"
               },
               body: params.to_json
             )
             .to_return(body: params.to_json)

      data = described_class.public_send(action, :objects, params)

      expect(stub).to have_been_made
      expect(data["name"]).to eq "objectname"
    end

    context "when the API returns a successful response without a body" do
      it "returns an empty hash" do
        stub_request(action, "#{Mergent.endpoint}/objects")
          .to_return(
            status: 204,
            body: nil
          )

        data = described_class.public_send(action, :objects, {})
        expect(data).to(eq({}))
      end
    end

    context "when the API returns an error with a body, without additional errors" do
      it "raises an Error" do
        stub_request(action, "#{Mergent.endpoint}/objects")
          .to_return(status: 422, body: { message: "A 422 has occurred." }.to_json)

        expect do
          described_class.public_send(action, :objects, {})
        end.to raise_error(Mergent::Error, "A 422 has occurred.")
      end
    end

    context "when the API returns an error with a body, including additional errors" do
      let(:body) do
        {
          message: "A 422 has occurred.",
          errors: [
            {
              message: "Name contains invalid characters"
            },
            {
              message: "Delay is not a valid ISO 8601 duration"
            },
            {
              message: "Request url is not a valid URL"
            }
          ]
        }
      end

      it "raises an Error" do
        stub_request(action, "#{Mergent.endpoint}/objects")
          .to_return(status: 422, body: body.to_json)

        expect do
          described_class.public_send(action, :objects, {})
        end.to raise_error(
          Mergent::Error,
          "A 422 has occurred. - Name contains invalid characters, Delay is not a valid ISO 8601 duration, "\
          "Request url is not a valid URL"
        )
      end
    end

    context "when the API returns an error without a body" do
      it "raises an Error" do
        stub_request(action, "#{Mergent.endpoint}/objects")
          .to_return(status: 500)

        expect do
          described_class.public_send(action, :objects, {})
        end.to raise_error(Mergent::Error)
      end
    end

    context "when the API is unavailable" do
      it "raises a ConnectionError" do
        stub_request(action, "#{Mergent.endpoint}/objects")
          .to_raise(Errno::ECONNRESET)

        expect do
          described_class.public_send(action, :objects, {})
        end.to raise_error(Mergent::ConnectionError)
      end
    end
  end

  describe "#post" do
    let(:action) { :post }

    include_examples "a client action"
  end

  describe "#delete" do
    let(:action) { :delete }

    include_examples "a client action"
  end

  describe "#patch" do
    let(:action) { :patch }

    include_examples "a client action"
  end
end
