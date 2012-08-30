class ActiveadminBlog::BlogPost
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search

  include ActionView::Helpers::TextHelper

  # Fields
  field :title
  field :content,   default: ''
  field :tags,      default: ''
  field :published, type: Boolean, default: false
  field :date,      type: Date
  field :slug,      default: ''

  # Callbacks
  set_callback(:save, :before) do |post|
    post.slug = post.title.to_url if post.slug.nil? or post.slug.empty?
  end

  # Validations
  validates :title, presence: true, uniqueness: true

  # Features
  search_in       :title, :content, :tags
  mount_uploader  :featured_image, ActiveadminBlog::FeaturedImageUploader
  paginates_per 6

  # Relations
  has_and_belongs_to_many :categories, :class_name => "ActiveadminBlog::BlogCategory"

  # Scopes
  default_scope order_by(:published => :asc).order_by({:date => :desc})
  scope         :published, where(published: true)

  # Indexes
  index :slug rescue index slug: 1
            # Mongoid 3.x workaround

  # Helpers
  def has_featured_image?
    not featured_image.to_s.empty?
  end

  def excerpt
    html = Nokogiri::HTML(content)
    begin
      html.css('p').select{|p| not p.content.empty? }.first.content
    rescue
      ""
    end
  end

  def page_description
    Nokogiri::HTML(excerpt).text
  end

  def new? # Mongoid 3.x
    new_record?
  end

  # Class methods
  def self.published_in_category(category_slug)
    category = ActiveadminBlog::BlogCategory.find_by(slug: category_slug)
    category.blog_posts.published
  end

  def self.published_in_month(month, year)
    begin
      start_date = Date.new(year, month, 1)
      end_date   = start_date + 1.month
    rescue
      self.published
    end
    self.published.where(:date=>{'$gte' => start_date,'$lt' => end_date})
  end

  def self.blog_search(query)
    self.search(query).published
  end

  def self.archive
    self.all.collect do |p|
      [p.date.month, p.date.year]
    end.uniq
  end

  def self.tagged_with(tag)
    self.published
  end
end
