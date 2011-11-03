class AddCreatedAtToMessageAssociation < ActiveRecord::Migration
  def change
  	remove_column(:message_associations, :updated_at)
  	add_timestamps(:message_associations)
  end
end
