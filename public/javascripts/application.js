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
  
  //messaging
  $('#recipients .users li').each(function(){
    $(this).append('<a>Remove</a>');
    $(this).find('a').click(function(){
      $(this)
        .parent()
        .removeClass('show')
        .find('input')
        .prop('checked',false);
    });
  });
  $('#recipients input').bind('keyup change', function(){
    text = $(this).val();
    if(text != $(this).data('text')) {
      $(this).data('text', text);
      $('#recipients .suggest').remove();
      if(text) {
        pattern = new RegExp(text,'i');
        names = new Array();
        matches = new Array();
        $('#recipients li').each(function(){
          if(!$(this).hasClass('show')) {
            names.push($(this).attr('title'));
          }
        });
        for(n=0; n<names.length; n++) {
          if(names[n].match(pattern)) {
            matches.push(names[n]);
            if(matches.length >= 10) {
              break;
            }
          }
        }
        if(matches.length > 0) {
          $('#recipients').append('<ul class="suggest"></ul>');
          for(m=0; m<matches.length; m++) {
            $('#recipients .suggest').append('<li>'+matches[m]+'</li>');
          }
          $('#recipients .suggest li').click(function(){
            $('#recipients .users li[title="'+$(this).html()+'"]')
              .addClass('show')
              .find('input')
              .attr('checked',true);
            $('#recipients input')
              .val('')
              .data('text', '')
              .focus();
            $('#recipients .suggest').remove();
          });
        }
      }
    }
  });
	
});

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).parent().before(content.replace(regexp, new_id));
}
