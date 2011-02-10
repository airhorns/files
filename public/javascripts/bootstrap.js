(function() {
  Backbone.history = new Backbone.History;
  jQuery(function($) {
    LDB.rootView = new LDB.ApplicationView();
    LDB.rootView.render();
    $('#application').append(LDB.rootView.el);
    new LDB.DashboardController();
    new LDB.LogsController();
    Backbone.history.start();
    LDB.notify("Signed in successfully.");
    return $('.flash').each(function(e) {
      LDB.notify(this.innerHTML);
      return $(this).remove();
    });
  });
}).call(this);
