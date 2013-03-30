ActiveAdmin.register CommunityUpgrade do
  menu parent: "Tabard", priority: 5, if: proc{ can?(:read, CommunityUpgrade) }
  controller.authorize_resource

  actions :index, :show
end
