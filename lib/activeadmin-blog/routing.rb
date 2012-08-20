module ActionDispatch::Routing
  class Mapper
    def mount_blog_at(mount_location)
      scope mount_location, :module => "ActiveadminBlog" do
        get '/'               => 'posts#index',     :as => :blog
        get '/search'         => 'posts#search',    :as => :blog_search
        get '/feed'           => 'posts#feed',      :as => :blog_rss_feed
        get '/archive/:y/:m'  => 'posts#archive',   :as => :blog_archive
        get '/tags/:tag'      => 'posts#tag',       :as => :blog_tag
        get '/posts/:slug'    => 'posts#show',      :as => :blog_post
        get '/:slug'          => 'posts#category',  :as => :blog_category    
      end
    end
  end
end