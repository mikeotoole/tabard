class RemoveLabelFromCommunities < ActiveRecord::Migration
  def change
    remove_column :communities, :label
  end
end
