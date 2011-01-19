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
  
});
