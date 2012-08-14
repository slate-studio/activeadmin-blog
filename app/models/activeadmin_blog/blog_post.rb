class ActiveadminBlog::BlogPost
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Search

  include ActionView::Helpers::TextHelper

  # Fields
  field :title
  field :content
  field :tags,      :default => ""
  field :published, :type => Boolean, :default => false
  field :date,      :type => Date

  # Validations
  validates_presence_of :title
  validates_uniqueness_of :title

  # Features
  slug            :title, :as => :permalink, :permanent => true
  search_in       :title, :content, :tags
  mount_uploader  :featured_image, ActiveadminSettings::RedactorPictureUploader
  paginates_per 6

  # Relations
  has_and_belongs_to_many :categories, :class_name => "ActiveadminBlog::BlogCategory"

  # Scopes
  default_scope order_by(:published => :asc).order_by({:date => :desc})
  scope         :published, where(published: true)

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

  # Class methods
  def self.published_in_category(category_slug)
    category = ActiveadminBlog::BlogCategory.find_by_permalink!(category_slug)
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
