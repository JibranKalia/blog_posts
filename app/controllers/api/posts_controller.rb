class Api::PostsController < ApplicationController
  def index
    begin
      params.require(:tags).permit(:sortBy).permit(:direction)
      sort_by = params[:sortBy].to_sym
      direction = params[:direction].to_sym

      @posts = BlogPost.get_posts_by_tags(params[:tags])
      @sorted_posts = BlogPost.sort_posts(@posts, sort_by: sort_by, direction: direction)

      render json: @sorted_posts
    rescue ActionController::ParameterMissing
      render json: { error: "Tags parameter is required" }, status: :bad_request
    end
  end
end
