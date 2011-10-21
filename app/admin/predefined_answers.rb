ActiveAdmin.register PredefinedAnswer do
  menu :parent => "CustomForm", :priority => 3
  controller.authorize_resource
end
