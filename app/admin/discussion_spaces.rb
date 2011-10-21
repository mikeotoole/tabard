ActiveAdmin.register DiscussionSpace do
  menu :parent => "Discussions"
  controller.authorize_resource 
end
