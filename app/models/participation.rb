class Participation
  include Mongoid::Document
  include Mongoid::Timestamps
  
  OWNER = 0
  ADMIN = 1
  MEMBER = 10
  
  field :level, type: Integer
  field :banned, type: Boolean, default: false
  field :hidden, type: Boolean, default: false
  
  belongs_to :forum, index: true
  belongs_to :user, index: true
    
  validates_presence_of :level, :forum, :user
  
  scope :owner, where(:level => OWNER)
  scope :admin, where(:level => ADMIN)
  
  def level_in_words
    case level
    when OWNER then "Owner"
    when ADMIN then "Admin"
    when MEMBER then "Member"
    else raise "invalid level"
    end
  end
end