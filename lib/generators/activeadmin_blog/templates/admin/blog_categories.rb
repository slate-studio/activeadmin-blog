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
    render :partial => "show", :locals => { :category => category }
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
