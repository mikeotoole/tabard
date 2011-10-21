ActiveAdmin.register SwtorCharacter do
  menu :parent => "Character"
  controller.authorize_resource
end
