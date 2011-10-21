ActiveAdmin.register Question do
  menu :parent => "CustomForm", :priority => 2
  controller.authorize_resource
end
