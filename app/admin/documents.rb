ActiveAdmin.register Document do
  menu :if => proc{ can?(:read, Document) }
  controller.authorize_resource :except => [:new_privacy_policy, :CreatePrivacyPolicy, :new_terms_of_service, :CreateTermsOfService]

  actions :index, :show

  filter :id
  filter :type, :as => :select
  filter :body
  filter :version
  filter :created_at
  filter :updated_at

  action_item :only => :index do
    if can? :create, Document
      link_to "New Privacy Policy", new_privacy_policy_admin_documents_path, :method => :get
    end
  end

  action_item :only => :index do
    if can? :create, Document
      link_to "New Terms Of Service", new_terms_of_service_admin_documents_path, :method => :get
    end
  end

  member_action :view_document, :method => :get do
    @document = Document.find(params[:id])
    if @document.is_a?(PrivacyPolicy)
      render 'app/views/crumblin/privacy_policy.haml', :layout => 'application'
    else
      render 'app/views/crumblin/terms_of_service.haml', :layout => 'application'
    end
  end

  collection_action :new_terms_of_service, :method => :get do
    authorize!(:create, Document)
    @document = TermsOfService.new
    render 'new_document'
  end

  collection_action :CreateTermsOfService, :method => :post do
    authorize!(:create, Document)
    document = TermsOfService.create(params[:document])
    if document.valid?
      flash[:notice] = 'Terms Of Service Created.'
      redirect_to admin_document_path(document)
    else
      @document = document
      render 'new_document'
    end
  end

  collection_action :new_privacy_policy, :method => :get do
    authorize!(:create, Document)
    @document = PrivacyPolicy.new
    render 'new_document'
  end

  collection_action :CreatePrivacyPolicy, :method => :post do
    authorize!(:create, Document)
    document = PrivacyPolicy.create(params[:document])
    if document.valid?
      flash[:notice] = 'Privacy Policy Created.'
      redirect_to admin_document_path(document)
    else
      @document = document
      render 'new_document'
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
    column "Current", :current?, :sortable => false
    column :created_at
  end

  show :title => :type do
    attributes_table *default_attribute_table_rows, :current?, :acceptance_count
    link_to "View Formatted", view_document_admin_document_path(document.id)
    #     active_admin_comments
  end
end
