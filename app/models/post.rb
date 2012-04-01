require 'uri'

class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Sunspot::Mongoid
  include Mongo::Voteable
  include GravityRanking
  include MarkdownProcessor
  
  field :title, type: String
  field :url, type: String, index: true
  field :text, type: String
  field :html, type: String
  field :ranking, type: Float, default: 0.0
  field :comment_count, type: Integer, default: 0
  
  index :ranking
  index :'votes.point'

  belongs_to :user, index: true
  belongs_to :forum, index: true
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :tags, inverse_of: nil, index: true

  validates_presence_of :title, :user, :forum
  validate :user_is_not_banned
  validate :url_is_new
  validate :presence_of_url_or_text
  validate :format_of_url
  
  voteable self, :up => +1, :down => -1
  
  before_save   :process_markdown
  after_create  :create_participation
  after_save    :update_post_counts
  after_destroy :update_post_counts
  
  searchable do
    text :title, :boost => 2.0, :stored => true
    text :url, :stored => true
    text :text, :stored => true
    text :comments_texts do
      comments.collect {|c| c.text }
    end
    string :forum_id, :references => Forum
    string :tag_ids, :multiple => true
  end
  
  def create_participation
    forum.add_member(user)
  end
  
  def user_is_not_banned
    errors.add(:base, "You can no longer participate in this forum") if user.banned_from?(forum)
  end
  
  def url_is_new
    if self.url.present?
      self.url = self.url.downcase
      if post = forum.posts.where(:url => self.url, :created_at.gt => 2.months.ago).first
        errors.add(:base, "That URL has already been submitted") unless post == self
      end
    end
  end
  
  def presence_of_url_or_text
    if self.url.blank? and self.text.blank?
      errors.add(:base, "Post can't be blank")
    end
  end
  
  def format_of_url
    if self.url.present?
      errors.add(:base, "Invalid URL") unless self.url =~ URI::regexp
    end
  end
  
  def update_post_counts
    if tag_ids_changed?
      tags.each do |t|
        t.update_attribute :posts_count, Post.all_in(:tag_ids => [t.id]).count
      end
    end
  end
  
  def self.with_tags names, forum
    if names.blank?
      scoped
    else
      names = names.split(',')
      tags = forum.tags.all_in(:name => names)
      all_in(:tag_ids => tags.collect{|t| t.id})
    end
  end
  
end