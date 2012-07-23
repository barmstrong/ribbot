class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongo::Voteable
  acts_as_nested_set
  include MarkdownProcessor
  
  field :text, type: String
  field :html, type: String
  field :deleted, type: Boolean, default: false
  field :ranking, type: Float, default: 0.0
  
  index :ranking
  index :'votes.point'

  belongs_to :user, index: true
  belongs_to :post, index: true
  belongs_to :forum, index: true
  
  validates_presence_of :text, :user, :post, :forum
  validate :user_is_not_banned
  
  voteable self, :up => +1, :down => -1
  
  before_save  :process_markdown
  after_create  :create_participation
  after_create  :inc_comment_count
  after_destroy :dec_comment_count
  
  attr_protected :parent_id
  
  def create_participation
    forum.add_member(user)
  end
  
  def inc_comment_count
    post.inc(:comment_count, 1)
  end
  
  def dec_comment_count
    post.inc(:comment_count, -1)
  end
  
  def user_is_not_banned
    errors.add(:base, "You can no longer participate in this forum") if user.banned_from?(forum)
  end
  
  def update_ranking
    if votes_point <= 0
      self.update_attribute :ranking, votes_point
    else
      self.update_attribute :ranking, ci_lower_bound(up_votes_count, votes_count)
    end
    reorder
  end
  
  # http://www.evanmiller.org/how-not-to-sort-by-average-rating.html
  def ci_lower_bound(pos, n, confidence=0.95)
    return 0 if n == 0
    z = 1.96 # Statistics2.pnormaldist(1-(1-confidence)/2)
    phat = 1.0*pos/n
    (phat + z*z/(2*n) - z * Math.sqrt((phat*(1-phat)+z*z/(4*n))/n))/(1+z*z/n)
  end
  
  # insertion sort to fixed the nested set when ranking changes
  def reorder
    sibs = siblings
    return if sibs.empty?
    sibs.each do |s|
      if self.ranking >= s.ranking
        self.move_to_left_of(s) and return
      end
    end
    self.move_to_right_of(sibs.last)
  end
end