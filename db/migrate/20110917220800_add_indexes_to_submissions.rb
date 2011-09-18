class AddIndexesToSubmissions < ActiveRecord::Migration
  def change
    add_index :submissions, :custom_form_id
    add_index :submissions, :user_profile_id
  end
end
