module GravityRanking
  # http://amix.dk/blog/post/19574
  def update_ranking
    gravity = 1.3
    p = self.votes_point.to_f
    t = ((Time.now.to_i - self.created_at.to_i) / 60 / 60) + 2
    ranking = p / t ** gravity
    self.update_attribute :ranking, ranking
  end
end