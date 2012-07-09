class BlogController < ApplicationController
  def index
    category_slug = params[:category]
    search_query  = params[:search]
    archive_month = params[:month]

    if category_slug
      category  = BlogCategory.find_by_permalink!(category_slug)
      @posts    = category.blog_posts.published
    elsif search_query
      @posts = BlogPost.blog_search(search_query)
    elsif archive_month
      month = archive_month.split("-")[0].to_i
      year  = archive_month.split("-")[1].to_i
      @posts = BlogPost.published_in(month, year)
    else
      @posts = BlogPost.published
    end

    @posts = @posts.page params[:page]
  end


  def post
    @post = BlogPost.find_by_permalink!(params[:slug])
  end


  def feed
    @posts = BlogPost.published

    respond_to do |format|
      format.rss { render :layout => false } #index.rss.builder
      format.all { head :not_found }
    end
  end
end
