ActiveAdmin.register CommunityPlan do
  menu parent: "Tabard", priority: 4, if: proc{ can?(:read, CommunityUpgrade) }
  controller.authorize_resource

  actions :index, :show, :update, :edit, :new, :create

  filter :id
  filter :title
  filter :description
  filter :price_per_month_in_cents
  filter :max_number_of_users
  filter :is_available, as: :select
  filter :created_at
  filter :updated_at

  index do
    column "View" do |community_plan|
      link_to "View", alexandria_community_plan_path(community_plan)
    end
    column :id
    column :title
    column :price_per_month_in_dollars do |community_plan|
      number_to_currency(community_plan.price_per_month_in_dollars)
    end
    column :is_available
    column :created_at
    column :updated_at
  end

  show title: :title do
    attributes_table *default_attribute_table_rows
    active_admin_comments
  end

  form do |f|
    f.inputs "Details (Note: this will NOT change values listed on Pricing page.)" do
      f.input :title
      f.input :description, hint: "Used on invoice"
      f.input :max_number_of_users
    end
    f.inputs "Price (Can only be changed on new plans)" do
      f.input :price_per_month_in_cents if f.object.new_record?
    end
    f.inputs "Danger Zone" do
      f.input :is_available
    end
    f.actions
  end
end
