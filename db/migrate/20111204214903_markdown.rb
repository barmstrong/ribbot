class Markdown < Mongoid::Migration
  def self.up
    Post.all.each do |p|
      p.process_markdown true
      p.save!
    end
    Comment.all.each do |c|
      c.process_markdown true
      c.save!
    end
  end

  def self.down
  end
end