class AddPositionToPredefinedAnswers < ActiveRecord::Migration
  def change
    add_column :predefined_answers, :position, :integer, :default => 0
  end
end
