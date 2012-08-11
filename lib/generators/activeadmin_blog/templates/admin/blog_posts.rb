ActiveAdmin.register ActiveadminBlog::BlogPost, :as => "Post" do
  menu :label => "Blog"

  actions :all, :except => [:show]

  # Scopes
  scope :published, :default => true
  scope :ideas

  controller do
    defaults :finder => :find_by_permalink
  end

  index do
    column("") do |p| # Blog post featured image thumbnail
      url = p.featured_image.thumb.url
      if url.nil?
        url = "http://placehold.it/118x100&text=NO+IMAGE"
      end
      image_tag(url, :alt => p.title, :size=>"118x100")
    end
    
    column("Title") do |p|
      html = "<p><strong>#{p.title}</strong><br/><em>#{truncate(p.excerpt, :length => 90)}</em></p>"
      
      if not p.tags.empty?
        html << "Tags: <em>" + p.tags.gsub(',', ', ') + "</em><br/>"
      end
      
      if p.categories.size > 0
        html << "Published in: " + p.categories.collect{|c| link_to(c.name, admin_category_path(c))}.join(", ")
      end
      html.html_safe
    end
    
    column("Status") do |p|
      """#{p.date.to_s.gsub('-', '/')}<br/>
         <i>#{p.published ? 'Published' : 'Not Finished'}</i>""".html_safe
    end

    default_actions
  end

  sidebar :categories, :only => :index do
    render :partial => "categories", :locals => { :categories => ActiveadminBlog::BlogCategory.all }
  end

  form do |f|
    f.inputs "Title" do
      f.input :title, :required => true
    end
    f.inputs "Content" do
      f.input :content, :as => :text,
                        :input_html => { :class => "redactor" }
    end
    f.inputs "Details" do
      
      if f.object.has_featured_image?
        featured_image_hint = image_tag f.object.featured_image.thumb.url, :size => "118x100"
      else
        featured_image_hint = ""
      end
      f.input :featured_image, :hint => featured_image_hint

      if f.object.has_featured_image?
        f.input :remove_featured_image, :as => :boolean
      end

      unless f.object.new?
        f.input :permalink
      end

      f.input :published, :as             => :select,
                          :label          => "State",
                          :collection     => [["published", "true"], ["not finished", "false"]],
                          :include_blank  => false,
                          :input_html     => { :class => "select2" }

      f.input :date,  :input_html => { :class => "datepicker", :placeholder => "Click field to pick date" }

      categories = ActiveadminBlog::BlogCategory.all
      if categories.size > 0
        f.input :categories,  :as             => :select,
                              :label          => "Published in",
                              :input_html     => { :multiple => true, :class => "select2" },
                              :collection     => categories,
                              :include_blank  => false,
                              :hint => "Click on field and select category from dropdown"
      end

      f.input :tags,  :hint       => "Select from the list or type a new one and press ENTER",
                      :input_html => { "data-url"  => "/admin/posts/tags" }
    end
    f.buttons
  end

  collection_action :tags, :method => :get do
    tags    = ActiveadminBlog::BlogPost.all.collect{ |p| p.tags }.join(",").split(',').uniq
    render :json => tags
  end
end
