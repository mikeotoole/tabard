class CreateCommunities < ActiveRecord::Migration
  def self.up
    create_table :communities do |t|
      t.string :name
      t.string :slogan
      t.string :label
      t.boolean :is_accepting_members, :default => true
      t.boolean :email_notice_on_application, :default => true
      t.string :subdomain

      t.timestamps
    end
  end

  def self.down
    drop_table :communities
  end
end
