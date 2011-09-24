class ViewLog < ActiveRecord::Base
###
# Associations
###
  belongs_to :user_profile
  belongs_to :view_loggable, :polymorphic => true
  
###
# Validators
###
  validates :user_profile, :presence => true
  validates :view_loggable, :presence => true  
end

# == Schema Information
#
# Table name: view_logs
#
#  id                 :integer         not null, primary key
#  user_profile_id    :integer
#  view_loggable_id   :integer
#  view_loggable_type :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

