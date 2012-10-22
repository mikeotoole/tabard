class AddFullNameToUserProfile < ActiveRecord::Migration
  def up
    add_column :user_profiles, :full_name, :string
    say_with_time "Adding first name & last name to full_name" do
      UserProfile.unscoped {
        UserProfile.all.each do |up|
          up.update_column(:full_name, "#{up.first_name} #{up.last_name}")
        end
      }
    end
    remove_column :user_profiles, :first_name
    remove_column :user_profiles, :last_name
  end
  def down
    raise  ActiveRecord::IrreversibleMigration
  end
end
