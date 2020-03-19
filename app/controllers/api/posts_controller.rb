class Api::PostsController < ApplicationController
  def index
    begin
      validate_params!

      tags = params[:tags].split(",")
      sort_by = params[:sortBy]&.to_sym
      direction = params[:direction]&.to_sym

      @posts = BlogPost.get_posts_by_tags(tags)
      @sorted_posts = BlogPost.sort_posts(@posts, sort_by: sort_by, direction: direction)
      render json: { posts: @sorted_posts }
    rescue RailsParam::Param::InvalidParameterError => e
      render json: { error: e.message }, status: :bad_request
    end
  end

  private

  def validate_params!
    param! :tags, String, required: true, message: "Tags parameter is required"
    param! :sortBy, String, in: %w(id reads likes popularity), message: "sortBy parameter is invalid"
    param! :direction, String, in: %w(asc desc), message: "direction parameter is invalid"
  end
end
