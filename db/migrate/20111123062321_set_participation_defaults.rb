class SetParticipationDefaults < Mongoid::Migration
  def self.up
    Participation.where(:banned => nil).update_all(:banned => false)
    Participation.where(:hidden => nil).update_all(:hidden => false)
  end

  def self.down
  end
end