class Discussion < ActiveRecord::Base
  belongs_to :user_profile
  belongs_to :character
  belongs_to :discussion_space
  has_many :comments, :as => :commentable
end
