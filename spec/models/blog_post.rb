require 'rails_helper'

RSpec.describe BlogPost, type: :model do
  before(:each) do
    stub_request(:get, "https://hatchways.io/api/assessment/blog/posts?tag=history")
      .to_return( status: 200, body: File.open(File.dirname(__FILE__) + '/fixtures/history.json').read, headers: {})
    stub_request(:get, "https://hatchways.io/api/assessment/blog/posts?tag=tech")
      .to_return( status: 200, body: File.open(File.dirname(__FILE__) + '/fixtures/tech.json').read, headers: {})
  end

  describe 'fetch posts' do
    it 'calls the api' do
      BlogPost.fetch_posts('history')
      expect(WebMock).to have_requested(:get, "https://hatchways.io/api/assessment/blog/posts").
        with(query: {"tag" => "history"})
    end

    it 'matches the expected response' do
      posts = BlogPost.fetch_posts('history')
      ids = posts.map { |hash| hash[:id] }

      expect(ids).to eq([2, 8, 10, 14, 16, 18, 37, 38, 39, 45, 50, 64, 65, 67, 69, 79, 80, 81, 84, 86, 88, 89, 93, 95, 96, 100])
    end
  end
end