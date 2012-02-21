class Theme
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  include Mongo::Voteable
  include GravityRanking
  
  field :name, type: String
  field :css, type: String
  field :public, type: Boolean, default: false
  field :ranking, type: Float, default: 0.0
  
  index :ranking
  index :'votes.point'
  
  has_many :forums, dependent: :nullify
  belongs_to :user, index: true
  
  validates_presence_of :name, :css, :user
  
  voteable self, :up => +1, :down => -1
end