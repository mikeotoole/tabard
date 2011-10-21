ActiveAdmin.register Page do
  menu :parent => "Pages"
  controller.authorize_resource
end
