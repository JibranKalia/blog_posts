require 'rails_helper'

RSpec.describe Api::PostsController, type: :controller do
  describe "#index" do
    before(:each) do
      stub_request(:get, "https://hatchways.io/api/assessment/blog/posts?tag=history")
        .to_return( status: 200, body: '{"posts":[{"author":"Zackery Turner","popularity":0.68}]}', headers: {})
    end

    it "returns correct posts" do
      get :index, params: { tags: "history", direction: "desc", sortBy: "popularity", format: :json }
      expect(response.body).to eq('{"posts":[{"author":"Zackery Turner","popularity":0.68}]}')
      assert_response :ok
    end

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