# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string(255)
#  info       :hstore
#  aliases    :string(255)
#

require 'spec_helper'

describe Game do
  let(:swtor) { create(:swtor) }
  let(:wow) { create(:wow) }
  let(:minecraft) { create(:minecraft) }

  it "should allow creation" do
    swtor.should be_valid
    wow.should be_valid
    minecraft.should be_valid
  end
end
