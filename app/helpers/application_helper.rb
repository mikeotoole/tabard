module ApplicationHelper
  # Creates a submit button with the given name with a cancel link 
  # Accepts two arguments: Form object and the cancel link name 
  
  #TODO If there are errors in the form and the user just presses cancel it redirects to the blank form. Any way to make this work better?
  def submit_or_cancel(form, name='Cancel')
    form.submit + " or " + link_to(name, 'javascript:history.go(-1);', :class => 'cancel')
  end
  
  def js_back
    link_to 'Back', 'javascript:history.go(-1);'
  end  
  
  def language_selector
    if I18n.locale == :en
      link_to "Local - Pirate", url_for(:locale => 'pirate') 
    else
      link_to "Local - En", url_for(:locale => 'en')
    end 
  end
  
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, '#{association}', '#{escape_javascript(fields)}')")
  end
  
end