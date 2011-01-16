class CreatePageSpaces < ActiveRecord::Migration
  def self.up
    create_table :page_spaces do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :page_spaces
  end
end
