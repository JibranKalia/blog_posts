require 'rails_helper'

RSpec.describe Api::PostsController, type: :controller do
  describe "#index" do
    it "should return 400 when tags missing" do
      get :index
      assert_response :bad_request
    end

    it "should return error message when tags missing" do
      get :index
      expect(response.body).to eq('{"error":"Tags parameter is required"}')
    end
  end
end