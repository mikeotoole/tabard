# == Schema Information
#
# Table name: site_configurations
#
#  id             :integer         not null, primary key
#  is_maintenance :boolean         default(FALSE)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe SiteConfiguration do
  pending "add some examples to (or delete) #{__FILE__}"
end
