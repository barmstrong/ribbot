class Forum
  include Mongoid::Document
  include Mongoid::Timestamps
  
  POST_OPTIONS = {
    text_or_url: 0,
    url_or_text: 1,
    text_only:   2,
    url_only:    3
  }
  
  field :subdomain, type: String
  field :name, type: String
  field :description, type: String
  field :custom_domain, type: String
  
  field :post_options, type: Integer, default: POST_OPTIONS[:text_or_url]
  
  field :post_label, type: String, default: "Post"
  field :posts_label, type: String, default: "Posts"
  field :new_post_label, type: String, default: "New Post"
  field :comment_label, type: String, default: "Comment"
  field :comments_label, type: String, default: "Comments"
  field :new_comment_label, type: String, default: "Add Comment"
  
  index :subdomain, unique: true
  index :custom_domain, unique: true
  
  has_many :posts
  has_many :participations, :dependent => :destroy
  has_many :tags
  has_many :pages
  belongs_to :theme
  
  validates_presence_of :subdomain, :name
  validates_uniqueness_of :subdomain, :case_sensitive => false
  validates_uniqueness_of :custom_domain, :case_sensitive => false, :allow_blank => true
  validate :subdomain_uses_valid_characters
  validate :subdomain_uses_valid_name
  
  before_validation :set_default_name
  before_save :clean_params
  before_save :add_or_remove_custom_domain
  
  def subdomain_uses_valid_characters
    errors.add(:subdomain, "can only use numbers and letters") if subdomain =~ /[^a-z0-9\-]/i
  end
  
  def custom_domain_uses_valid_characters
    if custom_domain.present? and (custom_domain =~ /[^a-z0-9\-\.]/i or custom_domain =~ /ribbot\.com/i)
      errors.add(:custom_domain, "should be in the format www.example.com or forum.example.com")
    end
  end
  
  def subdomain_uses_valid_name
    errors.add(:subdomain, "is already taken") if ['blog','legal','www','help','contact','jobs','about','proxy'].include?(subdomain.downcase)
  end
  
  def add_or_remove_custom_domain
    if custom_domain_changed? and Rails.env.production?
      heroku_client = Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_API_KEY'])
      heroku_client.remove_domain('ribbot', custom_domain_was) if custom_domain_was.present?
      heroku_client.add_domain('ribbot', custom_domain) if custom_domain.present?
    end
  end
  
  def set_default_name
    if name.blank?
      self.name = subdomain.titleize
    end
  end
  
  def add_member user
    if p = participations.where(:user_id => user.id).first
      p.update_attribute :hidden, false if p.hidden?
    else
      participations.create!(:user => user, :level => Participation::MEMBER)
    end
  end
  
  def add_admin user
    participations.create!(:user => user, :level => Participation::ADMIN)
  end
  
  def add_owner user
    participations.create!(:user => user, :level => Participation::OWNER)
  end
  
  def clean_params
    self.subdomain = subdomain.downcase
    self.custom_domain = custom_domain.downcase if custom_domain.present?
  end
  
  def hostname
    if custom_domain.present?
      custom_domain
    else
      subdomain+"."+Ribbot::Application.config.action_mailer.default_url_options[:host]
    end
  end
end
