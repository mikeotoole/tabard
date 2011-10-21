ActiveAdmin.register WowCharacter do
  menu :parent => "Character"
  controller.authorize_resource
end
