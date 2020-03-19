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

  describe 'get_posts_by_tag' do
    let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) } 
    let(:cache) { Rails.cache }

    before do
      allow(Rails).to receive(:cache).and_return(memory_store)
      Rails.cache.clear
    end

    it 'caches response' do
      expect(cache.exist?('tech')).to be(false)
      BlogPost.get_posts_by_tag('tech')
      expect(cache.exist?('tech')).to be(true)
    end
  end

end