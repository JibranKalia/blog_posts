require 'rails_helper'

RSpec.describe Api::PingController, type: :controller do
  describe "#index" do
    it "should get index" do
      get :index
      assert_response :success
    end
  end
end