class BlogPost < ApplicationRecord
  DATASOURCE_URL = 'https://hatchways.io/api/assessment/blog/posts'.freeze

  def self.get_posts_by_tag(tag)
    Rails.cache.fetch(tag, expires_in: 12.hours) do
      fetch_posts(tag)
    end
  end

  private

  def self.fetch_posts(tag)
    response = Faraday.get(DATASOURCE_URL, {tag: tag}, {'Accept' => 'application/json'})
    posts = JSON.parse(response.body, symbolize_names: true)
    posts
  end
end