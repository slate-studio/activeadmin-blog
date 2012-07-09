class BlogImage
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields
  field :title

  # Features
  mount_uploader  :file,  BlogImageUploader

  # Relations
  belongs_to  :blog_post

  # Scopes
  default_scope order_by(:created_at => :desc)
end
