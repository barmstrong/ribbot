class Forum
  include Mongoid::Document
  include Mongoid::Timestamps
  
  POST_OPTIONS = {
    :text_or_url => 0,
    :url_or_text => 1,
    :text_only => 2,
    :url_only => 3
  }
  
  field :subdomain, type: String
  field :name, type: String
  field :description, type: String
  
  field :post_options, type: Integer, default: POST_OPTIONS[:text_or_url]
  
  field :post_label, type: String, default: "Post"
  field :posts_label, type: String, default: "Posts"
  field :new_post_label, type: String, default: "New Post"
  field :comment_label, type: String, default: "Comment"
  field :comments_label, type: String, default: "Comments"
  field :new_comment_label, type: String, default: "Add Comment"
  
  index :subdomain, unique: true
  
  has_many :posts
  has_many :participations
  has_many :tags
  
  validates_presence_of :subdomain, :name
  validates_uniqueness_of :subdomain, :case_sensitive => false
  validate :subdomain_uses_valid_characters
  validate :subdomain_uses_valid_name
  
  before_validation :set_default_name
  before_save :downcase_subdomain
  
  def subdomain_uses_valid_characters
    errors.add(:subdomain, "can only use numbers and letters") if subdomain =~ /[^a-z0-9]/i
  end
  
  def subdomain_uses_valid_name
    errors.add(:subdomain, "is already taken") if ['blog','legal','www','help','test','contact','jobs','about'].include?(subdomain.downcase)
  end
  
  def set_default_name
    if name.blank?
      self.name = subdomain.titleize
    end
  end
  
  def add_admin user
    participations.create!(:user => user, :level => Participation::ADMIN)
  end
  
  def add_member user
    if p = participations.where(:user_id => user.id).first
      p.update_attribute :hidden, false if p.hidden?
    else
      participations.create!(:user => user, :level => Participation::MEMBER)
    end
  end
  
  def downcase_subdomain
    self.subdomain = subdomain.downcase
  end
end
