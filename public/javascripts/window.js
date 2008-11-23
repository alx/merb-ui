$(document).ready(function(){
  windowPosition();
  $('.mui_click_window_close').click(function(){
    windowClose(this.id);
  });
  $('.mui_click_window_redirect').click(function(){
    windowOpen(this.id);
  });
  $('.mui_window_target').draggable({
    'containment': 'window',
    'handle': '.mui_window_bar'
  });
});
