class SystemResource < ActiveRecord::Base
  has_many :permissions, :as => :permissionable
end
