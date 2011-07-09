class CreateCommunities < ActiveRecord::Migration
  def self.up
    create_table :communities do |t|
      t.string :name
      t.string :subdomain
      t.string :slogan
      t.string :label
      t.boolean :accepting

      t.timestamps
    end
  end

  def self.down
    drop_table :communities
  end
end
