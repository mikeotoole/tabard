class AddExplanationAndRequiredToQuestion < ActiveRecord::Migration
  def change
    add_column(:questions, :explanation, :string)
    add_column(:questions, :required, :boolean, :default => false)
  end
end
