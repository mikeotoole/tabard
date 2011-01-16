class DropTeamSpeaks < ActiveRecord::Migration
  def self.up
    drop_table :team_speaks
  end

  def self.down
    create_table :team_speaks do |t|

      t.timestamps
    end
  end
end
