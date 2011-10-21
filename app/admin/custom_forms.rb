ActiveAdmin.register CustomForm do
  menu :parent => "CustomForm", :priority => 1
  controller.authorize_resource
end
