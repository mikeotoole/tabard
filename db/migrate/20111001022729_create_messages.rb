class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :subject
      t.text :body
      t.integer :author_id
      t.integer :number_recipients
      t.boolean :system_sent, :default => false

      t.timestamps
    end

    add_index :messages, :author_id
  end
end
