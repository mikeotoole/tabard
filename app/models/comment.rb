class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :character
  belongs_to :user_profile
  has_many :comments, :as => :commentable
  
  # The commentable_type always needs to be of the base class type and not the subclass type.
  def commentable_type=(sType)
    super(sType.to_s.classify.constantize.base_class.to_s)
  end
  
end
