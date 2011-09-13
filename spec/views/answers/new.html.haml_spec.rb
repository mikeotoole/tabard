require 'spec_helper'

describe "answers/new.html.haml" do
  before(:each) do
    assign(:answer, stub_model(Answer,
      :body => "MyText",
      :question_id => 1,
      :type => "",
      :submission_id => 1
    ).as_new_record)
  end

  it "renders new answer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => answers_path, :method => "post" do
      assert_select "textarea#answer_body", :name => "answer[body]"
      assert_select "input#answer_question_id", :name => "answer[question_id]"
      assert_select "input#answer_type", :name => "answer[type]"
      assert_select "input#answer_submission_id", :name => "answer[submission_id]"
    end
  end
end
