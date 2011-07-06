jQuery.extend(jQuery.expr[':'], {
  focus: function(element) { 
    return element == document.activeElement; 
  }
});

$(document).ready(function() {
  
  //form field enhancements
  $('label').each(function() {
    if($(this).attr('for')) {
      field = $('#'+$(this).attr('for'));
    } else {
      field = $(this).find('input'); 
    }
    if(field) {
      fieldType = $(field).attr('type');
      switch(fieldType) {
        case 'checkbox':
          $(field)
            .bind('change', function() {
              if($(this).filter(':checked').length) {
                $(this).addClass('checked').parent().addClass('checked');
              } else {
                $(this).removeClass('checked').parent().removeClass('checked');
              }
            });
          $(this).has('input:checked').addClass('checked').find('input:checked').addClass('checked');
        break;
        case 'radio':
          $(field)
            .bind('change', function() {
              $('input[name="' + $(this).attr('name') + '"]').removeClass('checked').parent().removeClass('checked');
              $(this).addClass('checked').parent().addClass('checked');
            })
            .trigger('change');
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
    }
  });
  $('select').each(function(){
    select_id = $(this).attr('id');
    selectbox_id = 'selectbox_' + select_id;
    $(this)
      .css({ opacity: 0 })
      .before('<dl id="' + selectbox_id + '" class="selectbox"><dt>' + $(this).find('option:selected').html() + '</dt></dl>')
      .find('option')
      .each(function(){
        s = $(this).attr('selected') == true ? ' class="selected"' : '';
        $('#' + selectbox_id + ' dt').after('<dl' + s + ' value="' + $(this).val() + '">' + $(this).html() + '</dl>');
      });
    $('#' + selectbox_id + ' dl').click(function(){
      $(this).parent().find('dl').removeClass('selected');
      $(this)
        .addClass('selected')
        .parent().find('dt').html($(this).html());
      $('#' + select_id + ' option[value="' + $(this).attr('value') + '"]').attr('selected', 'selected');
    });
  });
  
  //announcements
  $('#announcements').find('.notice, .alert').append('<a class="dismiss" title="Dismiss message">Dismiss message</a>');
  $('#announcements .dismiss').bind('click', function(){
    $(this).parent('li').slideUp(300, function(){
      $(this).remove();
      if(!$('#announcements li').length) {
        $('#announcements').animate({ marginBottom: 0 }, 100, function() { $(this).remove(); });
      }
    });
  });
  
  //search
  $('#menu .search input, #menu .search button')
    .focus(function(){ $(this).parents('li').addClass('focus'); })
    .blur(function(){ $(this).parents('li').removeClass('focus'); });
  
  //tabs
  $('.tabs dt').click(function(){
    $(this).parent().find('.active').removeClass('active');
    $(this).parent().find('.' + $(this).attr('class')).addClass('active');
  });
  
  //messaging
  $('#recipients .users li').each(function(){
    $(this).append('<a>Remove</a>');
    $(this).find('a').click(function(){
      $(this)
        .parent()
        .removeClass('show')
        .find('input')
        .removeAttr('checked');
    });
  });
  $('#recipients input[type=text]').bind('keyup change', function(){
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
            $('#recipients input[type=text]')
              .data('text', '')
              .val('')
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
