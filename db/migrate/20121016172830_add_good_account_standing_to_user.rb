class AddGoodAccountStandingToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_in_good_account_standing, :boolean, default: true
  end
end
