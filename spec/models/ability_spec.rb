# == Schema Information
#
# Table name: answers
#
#  id            :integer         not null, primary key
#  body          :text
#  question_id   :integer
#  submission_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'
require "cancan/matchers"

describe Ability do
  ###
  # Here is a quick example to writing tests for cancan using the magical cancan matcher:
  #
  # Create some user => user = User.create!
  #   * This would most likely be the factory of your choice.
  #
  # Next you create cancan ability.
  # ability = Ability.new(user)
  #
  # Then you can test what they can and can't do:
  # ability.should be_able_to(:destroy, Project.new(:user => user))
  # ability.should_not be_able_to(:destroy, Project.new)
  #
  ###
  describe "baked in rules" do
    describe "An anonymous user" do
      let(:ability) { Ability.new(User.new) }
      pending
    end
  end
  describe "dynamic rules" do
    pending
  end
end
