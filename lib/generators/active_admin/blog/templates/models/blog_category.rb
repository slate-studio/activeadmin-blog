class BlogCategory
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  # Fields
  field :name
  field :_position, :type => Float, :default => 0.0

  # Validations
  validates_presence_of :name
  validates_uniqueness_of :name

  # Features
	slug :name, :as => :permalink, :permanent => true
  
  # Relations
  has_and_belongs_to_many :blog_posts

  # Scope
  default_scope order_by(:_position => :desc)
end