ActiveAdmin.register BlogPost, :as => "Post" do
  menu  :parent   => "Blog",
        :label    => "All Posts",
        :priority => 1

  actions :new, :create, :index, :update, :edit, :destroy

  # Scopes
  scope :all, :default => true
  scope :drafts
  scope :published

  controller do
    defaults :finder => :find_by_permalink
  end

  index do
    # Hiding this column until get support of images
    #column("") do |p| # Thumbnail
    #  url = p.featured_image.admin_thumb.url
    #  if url.nil?
    #    url = "http://placehold.it/60x40?text=IMG"
    #  end
    #  image_tag(url, :alt => p.title, :size=>"60x40")
    #end
    
    column("Title") do |p|
      html = "<strong>#{p.title}</strong>"
      html.html_safe
    end
    
    column("Details") do |p|
      html = ""
      if p.categories.size > 0
        html << "Published in: " + p.categories.collect{|c| link_to(c.name, admin_category_path(c))}.join(", ")
        html << "<br/>"
      end
      if not p.tags.empty?
        html << "Tags: <em>" + p.tags.gsub(',', ', ') + "</em>"
      end
      html.html_safe
    end
    
    column("Date") do |p|
      """#{p.date.to_s.gsub('-', '/')}<br/>
         <i>#{p.draft ? 'Draft' : 'Published'}</i>""".html_safe
    end

    default_actions
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
      unless f.object.new?
        f.input :permalink
      end

      f.input :date,  :input_html => { :class => "datepicker" }

      f.input :draft, :as             => :select,
                      :label          => "State",
                      :collection     => [["draft", "true"], ["published", "false"]],
                      :include_blank  => false,
                      :input_html     => { :class => "select2" }

      categories = BlogCategory.all
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
    tags    = BlogPost.all.collect{ |p| p.tags }.join(",").split(',').uniq
    render :json => tags
  end
end
