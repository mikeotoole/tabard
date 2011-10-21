ActiveAdmin.register Discussion do
  menu :parent => "Discussions"
  controller.authorize_resource
end
