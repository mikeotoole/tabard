class SystemResource < ActiveRecord::Base
  #attr_accessible :name, :permissions
  
  has_many :permissions, :as => :permissionable
end

# == Schema Information
#
# Table name: system_resources
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

