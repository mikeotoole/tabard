var hash = window.location.hash.slice(1);

jQuery.extend(jQuery.expr[':'], {
  focus: function(element) { 
    return element == document.activeElement; 
  }
});

$(document).ready(function() {

  //hash tab handling
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
  
  //form field enhancements
  $('label').each(enhance_field);
  $('select').each(enhance_select);
  
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
  
  //auto-suggest
  $('.suggest input[type="text"]')
    .live('change keyup focus mouseenter', suggest_input);
  $('.suggest .suggestions')
    .live('mouseleave', suggest_input_hide);
  $('.suggest .suggestions label')
    .live('click', suggest_select);
	
});


function enhance_field() {
  if($(this).attr('for')) {
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
}
function enhance_select() {
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
}


function suggest_input(e) {
  $('.suggest')
    .not($(this).parents('.suggest'))
    .removeClass('active')
    .find('.suggestions li')
    .removeClass('show');
  $(this)
    .parents('.suggest')
    .addClass('active');
  $(this)
    .siblings('.suggestions')
    .find('li')
    .removeClass('first last');
  val = $(this).val();
  test = val.replace(/\s/g, '');
  if(test.length) {
    pattern = new RegExp(test, 'i');
    $(this)
      .siblings('.suggestions')
      .find('label')
      .each(function() {
        if(!$(this).siblings('input[type="checkbox"]:checked').length) {
          item = $(this).html().replace(/\s/g, '');
          if(item.match(pattern) && $(this).html() != val) {
            $(this).parents('li').addClass('show');
          } else {
            $(this).parents('li').removeClass('show');
          }
        }
      });
    matches = $(this).siblings('.suggestions').find('li.show');
    if(matches.length) {
      $(matches[0]).addClass('first');
      $(matches[4]).addClass('last').nextAll().removeClass('show'); //only show the first 5
    }
  } else {
    suggest_input_hide(e, this);
  }
}
function suggest_input_hide(e, node) {
  if(!node) node = this;
  if(!$(node).hasClass('suggest')) node = $(node).parents('.suggest');
  $(node).find('.suggestions li').removeClass('first last show');
}
function suggest_select(e) {
  container = $(this).parents('.suggest');
  //single match (radios)
  if(container.find('.suggestions input[type="radio"]').length) {
    container
      .find('input[type="text"]')
      .attr('value', $(this).html());
  //multiple matches (checkboxes)
  } else if(container.find('.suggestions input[type="checkbox"]').length) {
    container
      .find('input[type="text"]')
      .attr('value', '');
    if(!container.find('.matches').length) {
      container.prepend('<ul class="matches"></ul>');
    }
    if(!container.find('.matches label[for="' + $(this).attr('for') + '"]').length) {
      container
        .find('.matches')
        .append('<li><label for="' + $(this).attr('for') + '">' + $(this).html() + '</label></li>')
        .find('li:last label')
        .click(function(){
          $('#' + $(this).attr('for')).removeAttr('checked');
          $(this).parents('li').remove();
          container.find('input[type="text"]').trigger('keyup');
          return false;
        });
    }
  }
  container
    .find('.suggestions li')
    .removeClass('show');
  $(this)
    .siblings('input')
    .attr('checked', 'checked');
  return false;
}


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