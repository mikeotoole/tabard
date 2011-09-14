# == Schema Information
#
# Table name: predefined_answers
#
#  id                 :integer         not null, primary key
#  body               :text
#  select_question_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

describe PredefinedAnswer do
  pending "add some examples to (or delete) #{__FILE__}"
end
