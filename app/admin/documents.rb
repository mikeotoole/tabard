ActiveAdmin.register Document do
  menu :if => proc{ can?(:read, Document) }
  controller.load_resource :only => [:edit, :update]
  controller.authorize_resource

  actions :index, :show, :edit, :update, :create, :new

  filter :id
  filter :type, :as => :select, :collection => Document::VALID_TYPES
  filter :body
  filter :version
  filter :published, :as => :select
  filter :created_at
  filter :updated_at

  member_action :view_document, :method => :get do
    @document = Document.find(params[:id])
    if @document.is_a?(PrivacyPolicy)
      render 'app/views/top_level/privacy_policy.haml', :layout => 'application'
    else
      render 'app/views/top_level/terms_of_service.haml', :layout => 'application'
    end
  end

  index do
    column "View" do |document|
      link_to "View", admin_document_path(document)
    end
    column "View Formatted" do |document|
      link_to "View Formatted", view_document_admin_document_path(document)
    end
    column :id
    column :type
    column :version
    column :published
    column "Is Current", :is_current?, :sortable => false
    column :created_at
  end

  show :title => :type do
    attributes_table *default_attribute_table_rows, :is_current?, :acceptance_count
    link_to "View Formatted", view_document_admin_document_path(document.id)
    #     active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :type, :as => :select, :collection => Document::VALID_TYPES
      f.input :version
      f.input :body
      f.input :published
    end
    f.buttons
  end
end
