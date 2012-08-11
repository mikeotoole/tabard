class AddEmailToCommunityInvites < ActiveRecord::Migration
  def change
    add_column :community_invites, :email, :string
  end
end
