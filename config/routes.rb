ActiveadminBlog::Engine.routes.draw do
  get '/'                 => 'posts#index',     :as => :blog
  get '/search'           => 'posts#search',    :as => :blog_search
  get '/:slug'            => 'posts#category',  :as => :blog_category
  get '/archive/:y/:m'    => 'posts#archive',   :as => :blog_archive
  get '/tags/:tag'        => 'posts#tag',       :as => :blog_tag
  get '/posts/:slug'      => 'posts#show',      :as => :blog_post
  get '/feed'             => 'posts#feed',      :as => :blog_rss_feed
end
