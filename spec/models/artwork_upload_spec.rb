# == Schema Information
#
# Table name: artwork_uploads
#
#  id               :integer         not null, primary key
#  email            :string(255)
#  attribution_name :string(255)
#  attribution_url  :string(255)
#  artwork_image    :string(255)
#  document_id      :integer
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

require 'spec_helper'

describe ArtworkUpload do
  pending "add some examples to (or delete) #{__FILE__}"
end
