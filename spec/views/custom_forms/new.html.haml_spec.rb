# require 'spec_helper'
# 
# describe "custom_forms/new.html.haml" do
#   before(:each) do
#     assign(:custom_form, stub_model(CustomForm,
#       :name => "MyString",
#       :message => "MyText",
#       :thankyou => "MyString",
#       :community_id => 1
#     ).as_new_record)
#   end
# 
#   it "renders new custom_form form" do
#     render
# 
#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "form", :action => custom_forms_path, :method => "post" do
#       assert_select "input#custom_form_name", :name => "custom_form[name]"
#       assert_select "textarea#custom_form_message", :name => "custom_form[message]"
#       assert_select "input#custom_form_thankyou", :name => "custom_form[thankyou]"
#       assert_select "input#custom_form_community_id", :name => "custom_form[community_id]"
#     end
#   end
# end
