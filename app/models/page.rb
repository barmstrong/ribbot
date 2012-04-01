class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActsAsList::Mongoid
  
  field :name, type: String
  field :text, type: String
  field :url, type: String
  
  belongs_to :forum, index: true
  
  acts_as_list :scope => :forum_id
  
  attr_protected :forum_id
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :forum_id, :case_sensitive => false
  validate :presence_of_text_or_url
  validate :format_of_url
  
  after_save :update_forum_timestamp
  after_destroy :update_forum_timestamp
  
  def presence_of_text_or_url
    if text.blank? and url.blank?
      errors.add(:base, "You must enter some text or a url.")
    end
  end
  
  def format_of_url
    if url.present?
      self.url = "http://#{url}" unless url =~ /^http:\/\//i
      errors.add(:base, "Invalid URL") unless url =~ URI::regexp
    end
  end
  
  def text?
    url.blank?
  end
  
  def url?
    url.present?
  end
  
  def update_forum_timestamp
    forum.update_attribute :updated_at, Time.now
  end
end