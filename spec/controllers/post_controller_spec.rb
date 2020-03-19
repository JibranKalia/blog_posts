require 'rails_helper'

RSpec.describe Api::PostsController, type: :controller do
  describe "#index" do
    describe "errors" do
      it "should return 400 and error message when tags missing" do
        get :index
        expect(response.body).to eq('{"error":"Tags parameter is required"}')
        assert_response :bad_request
      end

      it "should return 400 when direction incorrect" do
        get :index, params: { tags: "history", direction: "hi", format: :json }
        expect(response.body).to eq('{"error":"direction parameter is invalid"}')
        assert_response :bad_request
      end

      it "should return 400 when sortBy incorrect" do
        get :index, params: { tags: "history", sortBy: "hi", format: :json }
        expect(response.body).to eq('{"error":"sortBy parameter is invalid"}')
        assert_response :bad_request
      end
    end
  end
end