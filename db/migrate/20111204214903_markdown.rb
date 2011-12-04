class Markdown < Mongoid::Migration
  def self.up
    puts "Processing posts..."
    Post.all.each do |p|
      puts p.id
      p.process_markdown true
      p.save!
    end
    puts "Processing comments..."
    Comment.all.each do |c|
      puts c.id
      c.process_markdown true
      c.save!
    end
  end

  def self.down
  end
end