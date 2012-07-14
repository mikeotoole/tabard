class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.text :markup
      t.integer :character_proxy_id
      t.integer :user_profile_id
      t.integer :page_space_id
      t.boolean :show_in_navigation, default: false

      t.timestamps
    end

    add_index :pages, :character_proxy_id
    add_index :pages, :user_profile_id
    add_index :pages, :page_space_id
  end
end
