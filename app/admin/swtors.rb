ActiveAdmin.register Swtor, :as => "Swtor" do
  menu :label => "Game Star Wars", :parent => "Game and Character", :if => proc{ can?(:read, Swtor) }
  controller.authorize_resource

  actions :index, :show, :edit, :update, :new, :create

  filter :id
  filter :faction, :as => :select, :collection => Swtor::VALID_FACTIONS
  filter :server_name
  filter :server_type, :as => :select, :collection => Swtor::VALID_SERVER_TYPES
  filter :created_at
  filter :updated_at

  index do
    column "View" do |swtor|
      link_to "View", admin_swtor_path(swtor)
    end
    column :id
    column :faction
    column :server_name
    column :server_type
    column "Edit" do |swtor|
      if can? :edit, swtor
        link_to "Edit", edit_admin_swtor_path(swtor)
      end  
    end
  end

  show :title => :name do
    attributes_table *default_attribute_table_rows
#     active_admin_comments
  end
  
  form do |f|
    f.inputs "SWTOR Details" do
      f.input :faction, :as => :select, :collection => Swtor::VALID_FACTIONS
      f.input :server_name
      f.input :server_type, :as => :select, :collection => Swtor::VALID_SERVER_TYPES
    end
    f.buttons
  end  
end
