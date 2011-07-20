module ApplicationHelper
  
  # Creates a submit button with the given name with a cancel link 
  # Accepts two arguments: Form object and the cancel link name  
  #TODO If there are errors in the form and the user just presses cancel it redirects to the blank form. Any way to make this work better?
  def submit_or_cancel(form, text_button='Submit', text_back='Cancel')
    text_button = 'Submit' if text_button.blank?
    raw("<p class='submit'><button type='submit'>") + text_button + raw("</button>") + (
      (session[:last_page] != request.path_info) ? 
      raw(' or ' + link_to(text_back, session[:last_page], :class => 'cancel' )) : 
      ("")
      ) + raw('</p>')
  end
  
  def js_back
    link_to_if defined?session[:last_page], 'Back', session[:last_page]
  end
  
  def link_to_remove_fields(name, f, target='this', attributes='')
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(#{target})", attributes)
  end
  
  def link_to_add_fields(name, f, association, destination='this', before='', after='', attributes={})
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render association.to_s.singularize + "_fields", :f => builder
    end
    link_to_function(name, "add_fields(#{destination}, '#{association}', '#{escape_javascript(fields)}', '#{before}', '#{after}')", attributes)
  end
  
  # Removes all flash messages
  def clear_flash_messages
    flash[:messages] = nil
  end 
  
end