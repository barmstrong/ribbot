class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActsAsList::Mongoid
  
  field :name, type: String
  field :posts_count, type: Integer, default: 0
  
  belongs_to :forum, index: true
  
  acts_as_list :scope => :forum_id
  
  attr_protected :forum_id
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :forum_id, :case_sensitive => false
end