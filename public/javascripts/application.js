var hash = window.location.hash.slice(1);

jQuery.extend(jQuery.expr[':'], {
  focus: function(element) { 
    return element == document.activeElement; 
  }
});

$(document).ready(function() {

  $(window).bind('hashchange', function(){
    hash = window.location.hash.slice(1);
    if(hash != '' && hash != '#') {
      if(hash && $('.tabs .'+hash).length) {
        $('.tabs .active').removeClass('active');
        $('.tabs .' + hash).addClass('active');
      }
    }
    return false;
  })
  .trigger('hashchange');
  
  //text field enhancements
  $('label').each(function() {
    if ($(this).attr('for')) {
      field = $('#'+$(this).attr('for'));
    } else if($(this).find('input')) {
      field = $(this).find('input');
    } else {
      field = false;
    }
    fieldType = $(field).attr('type');
    if(fieldType && fieldType.match(/text|email/i)) {
      $(field)
        .data('default', $.trim($(field).attr('title')))
        .removeAttr('title')
        .bind('focus', function() {
          value = $(this).val();
          if($.trim(value)==$(this).data('default')) $(this).attr('value','');
        })
        .bind('blur', function() {
          value = $(this).val();
          if($.trim(value)=='') $(this).attr('value',$(this).data('default'));
        })
        .trigger('focus')
        .trigger('blur');
    }
  });
  
  //select field enhancements
  $('select').each(function(){
    select_id = $(this).attr('id');
    selectbox_id = 'selectbox_' + select_id;
    $(this)
      .css({ opacity: 0 })
      .before('<dl id="' + selectbox_id + '" class="selectbox"><dt' + (($(this).val()=='') ? ' class="unselected"' : '') + '>' + (($(this).val()=='') ? '&mdash;' : $(this).find('option:selected').html()) + '</dt></dl>')
      .find('option')
      .each(function(){
        s = $(this).attr('selected') == true ? ' class="selected"' : '';
        indent = $(this).parents('optgroup').length ? '&mdash;' : '';
        html = indent + $(this).html().replace(/\-\-/, '&mdash;');
        $('#'+selectbox_id).append('<dd' + s + ' value="' + $(this).val() + '"><a>' + html + '</a></dd>');
      });
    $('#'+selectbox_id + ' dd[value!=""]').click(function(){
      $(this).parent().find('dd').removeClass('selected');
      $(this)
        .addClass('selected')
        .parent().find('dt').removeClass('unselected').html($(this).find('a').html());
      $('#'+select_id + ' option[value="' + $(this).attr('value') + '"]').attr('selected', 'selected');
      $('#'+select_id).width($(this).parent().width());
    });
    $('#'+select_id).width($('#' + selectbox_id + ' dd[value="' + $('#'+select_id).val() + '"] a').width() + 47);
    $('#'+selectbox_id+' dd[value=]').hide();
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
  
  $('.suggest')
    .hide()
    .siblings('input[type=text]')
    .bind('keyup', function(){
      pattern = new RegExp($(this).val().replace(/\s/, ''), 'i');
      $(this)
        .siblings('.suggest')
        .show()
        .find('li')
        .each(function() {
          $(this).hide();
          if($(this).html().replace(/\s/, '').match(pattern)) {
            $(this).stop().show();
          } else {
            $(this).hide(200);
          }
        });
    });
  $('.suggest li').bind('click', function() {
    container = $(this).parent().parent();
    $(this).parent()
      .hide()
      .siblings('input[type=hidden]')
      .attr('value', $(this).attr('data'))
      .siblings('input[type=text]')
      .attr('value', '');
    if(!container.find('.matches').length) {
      container.prepend('<ul class="matches"></ul>');
    }
    container
      .find('.matches')
      .append('<li>' + $(this).html() + '</li>');
  });
	
});

function remove_fields(node, limit, parent, child) {
  if(limit) {
    if($(parent).find(child).length > limit) {
      $(node).remove();
    } else {
      alert('You must keep at least ' + limit + '.');
    }
  } else {
    $(node).remove();
  }
  return false;
}

function add_fields(link, association, content, before, after) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).after(before + content.replace(regexp, new_id) + after);
  return false;
}
