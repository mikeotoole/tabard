###
# This model represents a role.
###
class Role < ActiveRecord::Base

###
# Associations
###
  belongs_to :community

###
# Validators
###
  validates :community, :presence => true
  validates :name, :uniqueness => {:scope => :community_id}
end

# == Schema Information
#
# Table name: roles
#
#  id               :integer         not null, primary key
#  community_id     :integer
#  name             :string(255)
#  system_generated :boolean         default(FALSE)
#  created_at       :datetime
#  updated_at       :datetime
#

