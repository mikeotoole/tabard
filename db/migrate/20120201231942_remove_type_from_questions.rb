class RemoveTypeFromQuestions < ActiveRecord::Migration
  def up
    remove_column(:questions, :type)
  end

  def down
    add_column(:questions, :type, :string)
  end
end
