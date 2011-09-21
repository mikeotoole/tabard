class RenameMessageToInstructionsInCustomForm < ActiveRecord::Migration
  def change
    rename_column(:custom_forms, :message, :instructions)
  end
end
