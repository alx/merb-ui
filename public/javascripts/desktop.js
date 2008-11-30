// Set the status of the window. 0 == closed, 1 == opened
var windowStatus = 0;

// Position message at top center.
function messagePosition(){
  var browserWidth = $(window).width();
  var messageWidth = $('.mui_message').width();
  $('.mui_message').css({position:'fixed', left:(browserWidth/2)+(messageWidth/2)*(-1), top:0}).slideDown('fast');
}

// Close window.
function windowClose(url){
  $('.mui_window_target').fadeOut(function(){
    windowStatus = 0;
	});
}

// Open window and give the first input with class of mui_focus focus, if one exists.
function windowOpen(url){
  var target = $('.mui_window_target')
  target.load(url, function(){
    if(windowStatus == 0){
      target.fadeIn();
    }
    $('.mui_focus:first').focus();
    windowStatus = 1;
	});
}

// Position window at middle center.
function windowPosition(){
  if(windowStatus == 0){
    var browserWidth = $(window).width();
    var browserHeight = $(window).height();
    var windowWidth = $('.mui_window_target').width();
    var windowHeight = $('.mui_window_target').height();
    if (windowWidth > browserWidth){
      $('.mui_window_target').css({position:'absolute', left:'1em'});
    }
    else{
      $('.mui_window_target').css({position:'fixed', left:(browserWidth/2)+(windowWidth/2)*(-1)});
    }
    if (windowHeight > browserHeight){
      $('.mui_window_target').css({position:'absolute', top:'1em'});
    }
    else{
      $('.mui_window_target').css({position:'fixed', top:(browserHeight/2)+(windowHeight/2)*(-1)});
    }
  }
}

// Bind buttons.
$(function(){
  $('.mui_click').click(function(){
    window.location = this.id;
  });
  $('.mui_click_window_open').click(function(){
    windowOpen(this.id);
  });
  $('.mui_click_message_close').click(function(){
    $('.mui_message').slideUp('fast', function(){
      $('.mui_message').remove();
    });
  });
  messagePosition();
});

// Bind keyboard shortcuts.
$(document).keybind('ctrl+shift+P', function(){
  windowOpen('/password/read');
});
$(document).keybind('ctrl+shift+esc', function(){
  window.location = '/password/exit';
});
$(document).keybind('esc', function(){
  if ($('.mui_message').length > 0){
    $('.mui_click_message_close').click();
  }
  else{
    $('.mui_click_window_close').click();
  }
});
$(document).keybind('left', function(){
  $('[name=previous]').click();
});
$(document).keybind('right', function(){
  $('[name=next]').click();
});
