class Role < ActiveRecord::Base
  has_many :permissions
end
