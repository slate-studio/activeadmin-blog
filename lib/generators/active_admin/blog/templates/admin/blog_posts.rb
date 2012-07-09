ActiveAdmin.register BlogPost, :as => "Post" do
  menu  :parent   => "Blog",
        :label    => "All Posts",
        :priority => 1

  actions :new, :create, :index, :update, :edit, :delete

  # Scopes
  scope :all, :default => true
  scope :drafts
  scope :published

  controller do
    defaults :finder => :find_by_permalink
  end

  index do
    column("") do |p|
      url = p.featured_image.admin_thumb.url
      if url.nil?
        url = "http://placehold.it/60x40?text=IMG"
      end
      image_tag(url, :alt => p.title, :size=>"60x40")
    end
    column("Title") do |p|
      html = "<strong>#{p.title}</strong>"
      #if p.author
      #  html << "<br/>by #{link_to p.author.name, admin_author_path(p.author)}"
      #end
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
    column("Date",        :admin_date)
    column "" do |p|
      #link_to("View", blog_post_path(p), :class => "member_link", :target => "_blank") +
      link_to("Edit", edit_admin_post_path(p), :class => "member_link") +
      link_to("Delete", admin_post_path(p), :method => :delete, :confirm => "Are you sure?", :class => "member_link")
    end
  end

  form do |f|
    f.inputs "Title" do
      f.input :title, :required => true
      f.input :featured_image, :hint => "#{f.object.featured_image.url}"
    end
    f.inputs "Content" do
      f.input :content, :as => :text
    end
    f.inputs "Details" do
      unless f.object.new?
        f.input :permalink
      end

      f.input :date,    :input_html => { :class => "datepicker" }
      #f.input :author,  :as             => :select,
      #                  :include_blank  => false

      f.input :draft, :as             => :select,
                      :label          => "State",
                      :collection     => [["draft", "true"], ["published", "false"]],
                      :include_blank  => false

      categories = BlogCategory.all
      if categories.size > 0
        f.input :categories,  :as             => :select,
                              :label          => "Published in",
                              :input_html     => { :multiple => true },
                              :collection     => categories,
                              :include_blank  => false,
                              :hint => "Click on field and select category from dropdown"
      end

      f.input :tags, :hint => "Select from the list or type a new one and press ENTER"
    end
    f.buttons
  end

  member_action :upload_image,  :method => :put do
    post  = BlogPost.find_by_permalink(params[:id])
    image = post.images.create!(:file => params[:file])
    html  = "<img src=\"#{image.file.url}\" alt=\"\" />".html_safe
    render :text => html
  end

  member_action :images,  :method => :get do
    post  = BlogPost.find_by_permalink(params[:id])
    json = post.images.collect {|i| { :thumb => i.file.admin_thumb.url, :image => i.file.url } }
    render :json => json
  end

  collection_action :tags, :method => :get do
    tags    = BlogPost.all.collect{ |p| p.tags }.join(",").split(',').uniq
    render :json => tags
  end
end
