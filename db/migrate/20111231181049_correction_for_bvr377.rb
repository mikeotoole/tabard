class CorrectionForBvr377 < ActiveRecord::Migration
  def up
    change_column :permissions, :id_of_subject, :integer
  end

  def down
    change_column :permissions, :id_of_subject, :string
  end
end
