$(function() {
  $('.about_page .pane-dependencies .dependency.group ul ul').each(function() {
    var that = $(this);
    that.prev('b').click(function() { that.toggle(5); });
    that.hide();
  });
});
