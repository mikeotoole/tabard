class Folder < ActiveRecord::Base
  #attr_accessible :name, :user, :messages, :parent
  #acts_as_tree
  belongs_to :user, :class_name => "UserProfile"
  has_many :messages, :class_name => "MessageCopy"
end

# == Schema Information
#
# Table name: folders
#
#  id              :integer         not null, primary key
#  user_profile_id :integer
#  parent_id       :integer
#  name            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

