class ActiveadminBlog::PostsController < ApplicationController
  before_filter :load_categories

  def load_categories
    @categories = ActiveadminBlog::BlogCategory.all
  end

  def index
    @posts = ActiveadminBlog::BlogPost.published
    @posts = @posts.page params[:page]
  end

  def search
    search_query  = params[:q]
    @posts = ActiveadminBlog::BlogPost.blog_search(search_query)
    @posts = @posts.page params[:page]
  end

  def category
    category_slug = params[:slug]
    @posts = ActiveadminBlog::BlogPost.published_in_category(category_slug)
    @posts = @posts.page params[:page]
  end

  def archive
    month = params[:m].to_i
    year  = params[:y].to_i
    @posts = ActiveadminBlog::BlogPost.published_in_month(month, year)    
    @posts = @posts.page params[:page]
  end

  def tag
    tag = params[:tag]
    @posts = ActiveadminBlog::BlogPost.tagged_with(tag)
    @posts = @posts.page params[:page]
  end

  def show
    @post = ActiveadminBlog::BlogPost.find_by(slug:params[:slug])
  end

  def feed
    @posts = ActiveadminBlog::BlogPost.published

    respond_to do |format|
      format.rss { render :layout => false } #index.rss.builder
      format.all { head :not_found }
    end
  end
end
