class CreateTeamSpeaks < ActiveRecord::Migration
  def self.up
    create_table :team_speaks do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :team_speaks
  end
end
