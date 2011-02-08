(function() {
  Backbone.history = new Backbone.History;
  jQuery(function($) {
    LDB.rootView = new LDB.ApplicationView();
    LDB.rootView.render();
    $('#application').append(LDB.rootView.el);
    new LDB.DashboardController();
    new LDB.LogsController();
    return Backbone.history.start();
  });
}).call(this);
