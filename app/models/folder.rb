class Folder < ActiveRecord::Base
  #acts_as_tree
  belongs_to :user, :class_name => "UserProfile"
  has_many :messages, :class_name => "MessageCopy"
end
