class AddPositionToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :position, :integer, :default => 0
  end
end
