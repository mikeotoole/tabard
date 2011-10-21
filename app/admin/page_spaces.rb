ActiveAdmin.register PageSpace do
  menu :parent => "Pages"
  controller.authorize_resource
end
