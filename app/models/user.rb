class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  include Mongo::Voter
  
  include Gravtastic
  gravtastic :size => 20, :secure => false
  
  field :name, :type => String
  field :email, :type => String
  field :password_digest, :type => String
  field :superuser, :type => Boolean, :default => false
  field :verification_token, :type => String
  field :verified_at, :type => DateTime
  field :password_reset_token, :type => String
  field :password_reset_sent_at, :type => DateTime
  field :rate_limit, :type => Integer
  field :website, :type => String
  field :location, :type => String
  field :about, :type => String

  index :email, unique: true
  index :verification_token, unique: true
  
  has_many :participations
  has_many :posts
  has_many :comments
  has_many :themes

  has_secure_password
  
  validates :email, :presence => true, :uniqueness => true, :email => true
  validates_presence_of :password, :on => :create
  validates_length_of :password, :minimum => 7, :unless => Proc.new {|u| u.password.nil? }
  
  attr_protected :password_digest, :superuser

  before_validation :downcase_email
  
  def downcase_email
    self.email = self.email.downcase
  end
  
  def generate_token column
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(:conditions => { column => self[column]})
  end
  
  def name
    val = self.read_attribute(:name)
    val.blank? ? "New User" : val
  end
  
  def forums
    Forum.any_in(:_id => participations.collect{|p| p.forum_id})
  end
  
  def member_of? forum
    Participation.exists?(:conditions => {:forum_id => forum.id, :user_id => self.id})
  end
  
  def admin_of? forum
    Participation.exists?(:conditions => {:forum_id => forum.id, :user_id => self.id, :level.lte => Participation::ADMIN})
  end
  
  def owner_of? forum
    Participation.exists?(:conditions => {:forum_id => forum.id, :user_id => self.id, :level.lte => Participation::OWNER})
  end
  
  def banned_from? forum
    Participation.exists?(:conditions => {:forum_id => forum.id, :user_id => self.id, :banned => true})
  end
  
  def send_password_reset forum=nil
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    Mailer.password_reset(self, forum).deliver
  end
  
  def verified?
    verified_at.present?
  end
  
  def send_verification_email forum=nil
    generate_token(:verification_token) if verification_token.nil?
    save!
    Mailer.email_verification(self, forum).deliver
  end
  
  def up_voted? voteable
    self.vote_value(voteable) == :up
  end
  
  def down_voted? voteable
    self.vote_value(voteable) == :down
  end
  
  # checks AND updates rate limit
  def over_rate_limit?
    window = 10.minutes.ago.to_i
    interval = 30.seconds.to_i
    
    return true if rate_limit.present? and rate_limit > Time.now.to_i
    if rate_limit.nil? or rate_limit < window
      self.rate_limit = window
    end
    self.rate_limit += interval
    self.save!
    false
  end
end