class BlogPost < ApplicationRecord
  DATASOURCE_URL = 'https://hatchways.io/api/assessment/blog/posts'.freeze

  def self.get_posts_by_tags(tags)
    set = Set.new()
    tags.each do |tag|
      set.merge(get_posts_by_tag(tag))
    end
    set
  end

  def self.sort_posts(posts, sort_by, direction)
    sorted_posts = posts.sort_by { |hash| hash[sort_by] }
    sorted_posts.reverse! if direction == :desc
    sorted_posts
  end

  private

  def self.get_posts_by_tag(tag)
    Rails.cache.fetch(tag, expires_in: 12.hours) do
      fetch_posts(tag)
    end
  end

  def self.fetch_posts(tag)
    response = Faraday.get(DATASOURCE_URL, {tag: tag}, {'Accept' => 'application/json'})
    posts = JSON.parse(response.body, symbolize_names: true).dig(:posts)
    posts
  end
end