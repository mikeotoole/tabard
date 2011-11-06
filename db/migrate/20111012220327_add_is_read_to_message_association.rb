class AddIsReadToMessageAssociation < ActiveRecord::Migration
  def change
    add_column :message_associations, :has_been_read, :boolean, :default => false
  end
end
