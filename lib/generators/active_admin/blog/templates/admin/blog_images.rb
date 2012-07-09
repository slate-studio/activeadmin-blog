ActiveAdmin.register BlogImage, :as => "Image" do
  menu :parent => "Blog", :label => "All Images", :priority  => 2

  actions :index, :edit, :update, :destroy

  index do
    column("") { |i| image_tag i.file.admin_thumb.url, :alt => i.title }
    column "Details" do |i|     
      if i.title
        html = "Title: <strong>" + i.title.to_s + "</strong>" + "<br/>"
      else
        html = "No Title<br/>"
      end

      html << "Attached to: "
      html << link_to(i.blog_post.title, edit_admin_post_path(i.blog_post)) if i.blog_post

      html.html_safe 
    end
    column "" do |i|
      link_to("View", i.file.url, :class => "member_link fancybox") +
      link_to("Edit", edit_admin_image_path(i), :class => "member_link") +
      link_to("Delete", admin_image_path(i), :method => :delete, :confirm => "Are you sure?", :class => "member_link")
    end
  end

  form do |f|
    f.inputs "Attributes" do
      f.input :title
      if f.object.file.to_s.nil?
        hint_html = ""
      else
        hint_html = link_to(f.object.file.url, f.object.file.url, :target => "_blank")
      end
      f.input :file, :hint => hint_html
      
      f.input :blog_post, :as             => :select,
                          :include_blank  => false
    end
    f.buttons
  end
end
