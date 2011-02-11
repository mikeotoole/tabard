jQuery.extend(jQuery.expr[':'], {
  focus: function(element) { 
    return element == document.activeElement; 
  }
});

$(document).ready(function() {
  
  //form field enhancements
  $('label').each(function() {
    field = '#' + $(this).attr('for');
    fieldType = $(field).attr('type');
    switch(fieldType) {
      case 'checkbox':
        checkbox = $(field);
        if(checkbox.length) {
          $(this).click(function() {
            fieldID = $(this).attr('for');
            checkbox = $(field).filter('[type="checkbox"]');
            if($(checkbox).filter(':checked').length) {
              $(this).removeClass('checked');
            } else {
              $(this).addClass('checked');
            }
          });
        }
      break;
      case 'text':
        title = $(field).attr('title');
        $(field)
          .bind('focus', function() {
            value = $(this).val();
            if($.trim(value)==$.trim(title)) $(this).val('');
          })
          .bind('blur', function() {
            value = $(this).val();
            if(!$.trim(value)) $(this).val(title);
          })
          .trigger('focus')
          .trigger('blur');
      break;
    }
  });
  
  //announcements
  $('#announcements').find('.notice, .alert').append('<a class="dismiss" title="Dismiss message">Dismiss message</a>');
  $('#announcements .dismiss').bind('click', function(){ $(this).parent('li').slideUp(300); });
  
  function remove_fields(link) {
	  $(link).prev("input[type=hidden]").val("1");
	  $(link).closest(".fields").hide();
	}
	
	function add_fields(link, association, content) {
	  var new_id = new Date().getTime();
	  var regexp = new RegExp("new_" + association, "g")
	  $(link).parent().before(content.replace(regexp, new_id));
	}
  
});
