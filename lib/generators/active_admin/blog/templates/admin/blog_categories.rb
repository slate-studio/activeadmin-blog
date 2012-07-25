ActiveAdmin.register BlogCategory, :as => "Category" do
  menu :parent => "Blog", :priority  => 3

  controller do
    defaults :finder => :find_by_permalink
  end

  index :as => :reorder_table do
    column :name
    default_actions
  end

  #show :title => :name do
  #  panel "Posts" do
  #    if category.blog_posts.size > 0
  #      table_for(category.blog_posts, {:class => "index_table blog_posts"}) do |t|
  #        post_table_item(t)
  #      end
  #    end
  #  end
  #end

  form do |f|
    f.inputs "Details" do
      f.input :name, :required => true
    end

    f.buttons
  end

  collection_action :reorder, :method => :put do
    render :text => resource_class.reorder_objects(params[:ids])
  end
end
