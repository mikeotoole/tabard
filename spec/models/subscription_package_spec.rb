# == Schema Information
#
# Table name: subscription_packages
#
#  id                :integer          not null, primary key
#  community_plan_id :integer
#  end_date          :date
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'spec_helper'

describe SubscriptionPackage do
  pending "add some examples to (or delete) #{__FILE__}"
end
