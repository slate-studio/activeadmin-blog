class BlogPost
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include ActionView::Helpers::TextHelper
  include Mongoid::Search

  require 'nokogiri'

  # Fields
  field :title
  field :content
  field :tags,  :default => ""
  field :draft, :type => Boolean, :default => true
  field :date,  :type => Date

  # Validations
  validates_presence_of :title
  validates_uniqueness_of :title

  # Features
  mount_uploader :featured_image, BlogImageUploader
  slug :title, :as => :permalink, :permanent => true
  search_in :title, :content, :tags
  paginates_per 10

  # Relations
  has_many    :images, :class_name => "BlogImage"
  has_and_belongs_to_many :categories, :class_name => "BlogCategory"

  # Scopes
  default_scope order_by(:date => :desc)
  scope         :drafts,    where(draft: true)
  scope         :published, where(draft: false)

  # Helpers
  def featured_image_url
    # This method should be changed if there is a custom version
    # of featured image defined in 'blog_image_uploader.rb'
    featured_image.url
  end

  def has_featured_image
    not featured_image_url.nil?
  end

  def in_categories
    # Category names splitted by comma
    categories.collect{|c| link_to(c.name, admin_category_path(c))}.join(", ")
  end

  def admin_date
    (date.to_s.gsub('-', '/') + "<br/>" + (draft ? "<i>Draft</i>" : "<i>Published</i>") ).html_safe
  end

  def excerpt
    html = Nokogiri::HTML(content)
    begin
      html.css('p').first.content
    rescue
      html.css('div').first.content
    rescue
      ""
    end
  end

  def page_description
    Nokogiri::HTML(excerpt).text
  end

  def self.blog_search(query)
    self.search(query).published
  end

  def self.archive
    BlogPost.all.collect do |p|
      [p.date.month, p.date.year]
    end.uniq
  end

  def self.published_in(month, year)
    begin
      start_date = Date.new(year, month, 1)
      end_date   = start_date + 1.month
    rescue
      BlogPost.published
    end
    BlogPost.published.where(:date=>{'$gte' => start_date,'$lt' => end_date})
  end
end
