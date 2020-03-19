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

  describe 'get_posts_by_tags' do
    let(:posts) { BlogPost.get_posts_by_tags(['history', 'tech']) }

    it 'only has unique records' do
      posts_ids = posts.map { |hash| hash[:id] }

      expect(posts_ids.length).to eq(posts_ids.uniq.length)
    end

    it 'has correct tags' do
      posts_tags = posts.map { |hash| hash[:tags] }

      posts_tags.each do |post_tags|
        expect(post_tags.include?('history') || post_tags.include?('tech')).to be(true)
      end
    end
  end

  describe 'sort_posts' do
    let(:posts) { BlogPost.get_posts_by_tags(['history', 'tech']) }

    it 'sorts by id ascending correctly' do
      sorted_posts = BlogPost.sort_posts(posts, :id, :asc)
      expect(sorted_posts.first[:author]).to eq("Rylee Paul")
      expect(sorted_posts.last[:author]).to eq("Ahmad Dunn")
    end

    it 'sorts by id descending correctly' do
      sorted_posts = BlogPost.sort_posts(posts, :id, :desc)
      expect(sorted_posts.first[:author]).to eq("Ahmad Dunn")
      expect(sorted_posts.last[:author]).to eq("Rylee Paul")
    end

    it 'sorts by reads ascending correctly' do
      sorted_posts = BlogPost.sort_posts(posts, :reads, :asc)
      expect(sorted_posts.first[:author]).to eq("Bryson Bowers")
      expect(sorted_posts.last[:author]).to eq("Lainey Ritter")
    end

    it 'sorts by reads descending correctly' do
      sorted_posts = BlogPost.sort_posts(posts, :reads, :desc)
      expect(sorted_posts.first[:author]).to eq("Lainey Ritter")
      expect(sorted_posts.last[:author]).to eq("Bryson Bowers")
    end

    it 'sorts by popularity ascending correctly' do
      sorted_posts = BlogPost.sort_posts(posts, :popularity, :asc)
      expect(sorted_posts.first[:author]).to eq("Jaden Bryant")
      expect(sorted_posts.last[:author]).to eq("Jon Abbott")
    end

    it 'sorts by popularity descending correctly' do
      sorted_posts = BlogPost.sort_posts(posts, :popularity, :desc)
      expect(sorted_posts.first[:author]).to eq("Jon Abbott")
      expect(sorted_posts.last[:author]).to eq("Jaden Bryant")
    end

    it 'sorts by likes ascending correctly' do
      sorted_posts = BlogPost.sort_posts(posts, :likes, :asc)
      expect(sorted_posts.first[:author]).to eq("Bryson Bowers")
      expect(sorted_posts.last[:author]).to eq("Jon Abbott")
    end

    it 'sorts by likes descending correctly' do
      sorted_posts = BlogPost.sort_posts(posts, :likes, :desc)
      expect(sorted_posts.first[:author]).to eq("Jon Abbott")
      expect(sorted_posts.last[:author]).to eq("Bryson Bowers")
    end
  end
end