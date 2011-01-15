class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :character
  belongs_to :user_profile
  has_many :comments, :as => :commentable
end
