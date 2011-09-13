require 'spec_helper'

describe "questions/new.html.haml" do
  before(:each) do
    assign(:question, stub_model(Question,
      :body => "MyText",
      :custom_form_id => 1,
      :type => "",
      :style => "MyString"
    ).as_new_record)
  end

  it "renders new question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => questions_path, :method => "post" do
      assert_select "textarea#question_body", :name => "question[body]"
      assert_select "input#question_custom_form_id", :name => "question[custom_form_id]"
      assert_select "input#question_type", :name => "question[type]"
      assert_select "input#question_style", :name => "question[style]"
    end
  end
end
