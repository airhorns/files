(function() {
  Backbone.history = new Backbone.History;
  jQuery(function($) {
    LDB.rootView = new LDB.ApplicationView();
    LDB.rootView.render();
    $('#application').append(LDB.rootView.el);
    new LDB.DashboardController();
    new LDB.LogsController();
    Backbone.history.start();
    return $('.flash').each(function(e) {
      LDB.notify({
        message: this.innerHTML,
        icon: "ui-icon-" + ($(this).attr('class').split(' ')[0])
      });
      return $(this).remove();
    });
  });
}).call(this);
