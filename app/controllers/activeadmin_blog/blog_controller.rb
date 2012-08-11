class ActiveadminBlog::BlogController < ApplicationController
  def index
    category_slug = params[:category]
    search_query  = params[:search]
    archive_month = params[:month]

    if    category_slug
      @posts = ActiveadminBlog::BlogPost.published_in_category(category_slug)
    elsif search_query
      @posts = ActiveadminBlog::BlogPost.blog_search(search_query)
    elsif archive_month
      month = archive_month.split("-")[0].to_i
      year  = archive_month.split("-")[1].to_i
      @posts = ActiveadminBlog::BlogPost.published_in_month(month, year)
    else
      @posts = ActiveadminBlog::BlogPost.published
    end

    @posts = @posts.page params[:page]
  end

  def post
    @post = ActiveadminBlog::BlogPost.find_by_permalink!(params[:slug])
  end

  def feed
    @posts = ActiveadminBlog::BlogPost.published

    respond_to do |format|
      format.rss { render :layout => false } #index.rss.builder
      format.all { head :not_found }
    end
  end
end
