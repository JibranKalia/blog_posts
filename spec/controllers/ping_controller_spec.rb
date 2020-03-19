require 'rails_helper'

RSpec.describe Api::PingController, type: :controller do
  describe "#index" do
    it "should return 200" do
      get :index
      assert_response :ok
    end

    it "should return correct body" do
      get :index
      expect(response.body).to eq('{"success":true}')
    end
  end
end