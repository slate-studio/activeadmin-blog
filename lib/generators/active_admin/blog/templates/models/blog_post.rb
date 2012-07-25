class BlogPost
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Search

  include ActionView::Helpers::TextHelper
  require 'nokogiri'

  # Fields
  field :title
  field :content
  field :tags,  :default => ""
  field :draft, :type => Boolean, :default => true
  field :date,  :type => Date

  field :featured_image # This is temporary value until redactor with file uploading functionality is off

  # Validations
  validates_presence_of :title
  validates_uniqueness_of :title

  # Features
  slug            :title, :as => :permalink, :permanent => true
  search_in       :title, :content, :tags
  paginates_per 6

  # Relations
  has_and_belongs_to_many :categories, :class_name => "BlogCategory"

  # Scopes
  default_scope order_by(:date => :desc)
  scope         :drafts,    where(draft: true)
  scope         :published, where(draft: false)

  # Helpers
  def has_featured_image?
    false
  end

  def category_links_string
    categories.collect{|c| link_to(c.name, admin_category_path(c))}.join(", ")
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
  def published_in_category(category_slug)
    category = BlogCategory.find_by_permalink!(category_slug)
    category.blog_posts.published
  end

  def self.published_in_month(month, year)
    begin
      start_date = Date.new(year, month, 1)
      end_date   = start_date + 1.month
    rescue
      BlogPost.published
    end
    BlogPost.published.where(:date=>{'$gte' => start_date,'$lt' => end_date})
  end

  def self.blog_search(query)
    self.search(query).published
  end

  def self.archive
    BlogPost.all.collect do |p|
      [p.date.month, p.date.year]
    end.uniq
  end
end
