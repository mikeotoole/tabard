class DiscussionSpace < ActiveRecord::Base
  belongs_to :user_profile
  belongs_to :game
  has_many :discussions
end
