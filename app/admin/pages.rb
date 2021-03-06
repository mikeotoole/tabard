ActiveAdmin.register Page do
  menu parent: "Pages", if: proc{ can?(:read, Page) }
  controller.authorize_resource

  actions :index, :show, :edit, :update, :destroy

  filter :id
  filter :name
  filter :markup
  filter :created_at

  index do
    column "View" do |page|
      link_to "View", alexandria_page_path(page)
    end
    column :id
    column :name
    column "Page Space" do |page|
      link_to page.page_space_name, [:alexandria, page.page_space]
    end
    column :created_at
    column "Edit" do |page|
      if can? :edit, page
        link_to "Edit", edit_alexandria_page_path(page)
      end
    end
    column "Destroy" do |page|
      if can? :destroy, page
        link_to "Destroy", [:alexandria, page], method: :delete, confirm: 'Are you sure you want to delete this page?'
      end
    end
  end

  show title: :name do
    attributes_table *default_attribute_table_rows, :community

    div do
      page.body
    end
    #active_admin_comments
  end
  form do |f|
    f.inputs "Page" do
      f.input :markup
    end
    f.actions
  end
end
