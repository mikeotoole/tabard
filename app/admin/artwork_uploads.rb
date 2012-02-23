###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an ActiveAdmin resource definition for managing Artwork Uploads.
###
ActiveAdmin.register ArtworkUpload do
  menu :parent => "Crumblin", :if => proc{ can?(:read, ArtworkUpload) }
  controller.authorize_resource

  actions :index, :show, :destroy

  filter :id
  filter :email
  filter :attribution_name
  filter :attribution_url

  index do
    column "View" do |artwork_upload|
      link_to "View", admin_artwork_upload_path(artwork_upload)
    end
    column :id
    column :email
    column :attribution_name
    column :attribution_url
    column :document, :sortable => :document_id
    column :created_at
  end

  show :title => :email do |artwork_upload|
    rows = default_attribute_table_rows
    
    attributes_table *rows do
      row :artwork_image do
        image_tag artwork_upload.artwork_image_url
      end
    end
    
    active_admin_comments
  end
end
