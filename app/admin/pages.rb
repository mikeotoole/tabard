ActiveAdmin.register Page do
  menu :parent => "Pages", :if => proc{ can?(:read, Page) }
  controller.authorize_resource

  actions :index, :show, :destroy

  filter :id
  filter :name
  filter :markup
  filter :created_at
  filter :show_in_navigation, :as => :select

  index do
    column "View" do |page|
      link_to "View", admin_page_path(page)
    end
    column :id
    column :name
    column "Page Space" do |page|
      link_to page.page_space_name, [:admin, page.page_space]
    end
    column :created_at
    column "Destroy" do |page|
      if can? :destroy, page
        link_to "Destroy", [:admin, page], :method => :delete, :confirm => 'Are you sure you want to delete this page?'
      end
    end
  end

  show :title => :name do
#     rows = default_attribute_table_rows.delete_if { |att| [:character_proxy_id].include?(att) }
#     rows.insert(1, :poster)
#     attributes_table *rows
    attributes_table *default_attribute_table_rows, :community

    div do
      page.body
    end
#     active_admin_comments
  end
end
