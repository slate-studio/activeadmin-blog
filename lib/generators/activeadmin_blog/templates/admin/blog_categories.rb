ActiveAdmin.register ActiveadminBlog::BlogCategory, :as => "Category" do
  menu false

  actions :all, :except => [:index]

  controller do
    def create
      create! do |format|
        format.html { redirect_to admin_posts_path }
      end
    end

    def update
      update! do |format|
        format.html { redirect_to admin_posts_path }
      end
    end

    def destroy
      destroy! do |format|
        format.html { redirect_to admin_posts_path }
      end
    end

    defaults :finder => :find_by_permalink
  end

  show :title => :name do
    ol :id => "category_posts_page" do
      li :class => "links" do
        link_to "All Posts", admin_posts_path, :class => "all-posts-button"
      end
      li do
        if category.blog_posts.size > 0
          table_for(category.blog_posts, {:class => "index_table category_posts"}) do |t|
    
            t.column("") do |p| # Blog post featured image thumbnail
              url = p.featured_image.thumb.url
              if url.nil?
                url = "http://placehold.it/118x100&text=NO+IMAGE"
              end
              image_tag(url, :alt => p.title, :size=>"118x100")
            end
            
            t.column("Title") do |p|
              html = "<p><strong>#{p.title}</strong><br/><em>#{truncate(p.excerpt, :length => 90)}</em></p>"
              
              if not p.tags.empty?
                html << "Tags: <em>" + p.tags.gsub(',', ', ') + "</em><br/>"
              end
              
              if p.categories.size > 0
                html << "Published in: " + p.categories.collect{|c| link_to(c.name, admin_category_path(c))}.join(", ")
              end
              html.html_safe
            end
            
            t.column("Status") do |p|
              """#{p.date.to_s.gsub('-', '/')}<br/>
                 <i>#{p.published ? 'Published' : 'Not Finished'}</i>""".html_safe
            end
    
            t.column "" do |p|
              link_to("Edit",   edit_admin_post_path(p), :class => "member_link") +
              link_to("Delete", admin_post_path(p),      :class => "member_link", :method => :delete, :confirm => "Are you sure?")
            end
          end
        else
          p "No posts here yet."
        end
      end
    end
  end

  sidebar :categories, :only => :show do
    render :partial => "admin/posts/categories", :locals => { :categories => ActiveadminBlog::BlogCategory.all }
  end

  form do |f|
    render :partial => "form", :locals => { :f => f }
  end

  collection_action :reorder, :method => :put do
    render :text => resource_class.reorder_objects(params[:ids])
  end
end
