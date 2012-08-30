class ActiveadminBlog::BlogCategory
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Reorder

  # Fields
  field :name
  field :slug,      default: ''
  field :_position, :type => Float, :default => 0.0

  # Callbacks
  set_callback(:save, :before) do |doc|
    doc.slug = doc.name.to_url if doc.slug.nil? or doc.slug.empty?
  end

  # Validations
  validates :name, presence: true, uniqueness: true

  # Relations
  has_and_belongs_to_many :blog_posts, :class_name => "ActiveadminBlog::BlogPost"

  # Scope
  default_scope order_by(:_position => :desc)

  # Indexes
  index :slug rescue index slug: 1
            # Mongoid 3.x workaround

  # Helpers       
  def new? # Mongoid 3.x
    new_record?
  end
end