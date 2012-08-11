ActiveadminBlog::Engine.routes.draw do
  get '/'             => 'blog#index', :as => :blog
  get '/feed'         => 'blog#feed',  :as => :blog_rss_feed
  get '/posts/:slug'  => 'blog#post',  :as => :blog_post
end
