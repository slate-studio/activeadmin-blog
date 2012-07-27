ActiveAdmin.register BlogCategory, :as => "Category" do
  menu :parent => "Blog", :priority  => 3

  controller do
    defaults :finder => :find_by_permalink
  end

  index :as => :reorder_table do
    column :name
    default_actions
  end

  show :title => :name do
    panel "Posts" do
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
               <i>#{p.draft ? 'Draft' : 'Published'}</i>""".html_safe
          end

          t.column "" do |p|
            link_to("Edit",   edit_admin_post_path(p), :class => "member_link") +
            link_to("Delete", admin_post_path(p),      :class => "member_link", :method => :delete, :confirm => "Are you sure?")
          end
        end
      end
    end
  end

  form do |f|
    f.inputs "Details" do
      f.input :name, :required => true
      f.input :permalink
    end

    f.buttons
  end

  collection_action :reorder, :method => :put do
    render :text => resource_class.reorder_objects(params[:ids])
  end
end
