# ActiveAdmin.register Comment do
#   menu :parent => "Discussions"
#   controller.authorize_resource
#   
#   filter :id
#   filter :body
#   filter :created_at
#   filter :has_been_deleted, :as => :select
#   filter :has_been_edited, :as => :select
#   filter :has_been_locked, :as => :select
#   
#   index do
#     column :id
#     column :body
#     column :user_profile
#     column :poster
#     column :created_at       
#     column "View" do |comment|
#       link_to "View", admin_comment_path(comment)
#     end
#     column "Destroy" do |comment|
#       if can? :destroy, comment
#         link_to "Destroy", [:admin, comment], :method => :delete, :confirm => 'Are you sure you want to delete this comment?'
#       end  
#     end
#   end
#   
#   show do
#     attributes_table :name, :body, :commentable, :user_profile, :poster, :community, :created_at, :updated_at, :has_been_deleted, :has_been_edited, :has_been_locked
#     # TODO Mike, Add sub comments.
#     active_admin_comments
#   end
# end

#  id                 :integer         not null, primary key
#  body               :text
#  user_profile_id    :integer
#  character_proxy_id :integer
#  community_id       :integer
#  commentable_id     :integer
#  commentable_type   :string(255)
#  has_been_deleted   :boolean         default(FALSE)
#  has_been_edited    :boolean         default(FALSE)
#  has_been_locked    :boolean         default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime