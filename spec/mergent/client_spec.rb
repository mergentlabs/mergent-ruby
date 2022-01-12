# frozen_string_literal: true

RSpec.describe Mergent::Client do
  before { Mergent.api_key = "abcd1234" }

  describe "#post" do
    it "makes a POST request to the specified resource, parsing the JSON body into an Object" do
      params = { name: "objectname" }
      stub = stub_request(:post, "https://api.mergent.co/v1/objects")
             .with(
               headers: {
                 Authorization: "Bearer #{Mergent.api_key}",
                 "Content-Type": "application/json"
               },
               body: params.to_json
             )
             .to_return(body: params.to_json)

      json = described_class.post(:objects, params)

      expect(stub).to have_been_made
      expect(json["name"]).to eq "objectname"
    end

    context "when the API returns an error with a body" do
      it "raises an Error" do
        stub_request(:post, "https://api.mergent.co/v1/objects")
          .to_return(status: 422, body: { message: "A 422 has occured." }.to_json)

        expect do
          described_class.post(:objects, {})
        end.to raise_error(Mergent::Error, "A 422 has occured.")
      end
    end

    context "when the API returns an error without a body" do
      it "raises an Error" do
        stub_request(:post, "https://api.mergent.co/v1/objects")
          .to_return(status: 500)

        expect do
          described_class.post(:objects, {})
        end.to raise_error(Mergent::Error)
      end
    end

    context "when the API is unavailable" do
      it "raises a ConnectionError" do
        stub_request(:post, "https://api.mergent.co/v1/objects")
          .to_raise(Errno::ECONNRESET)

        expect do
          described_class.post(:objects, {})
        end.to raise_error(Mergent::ConnectionError)
      end
    end
  end
end
