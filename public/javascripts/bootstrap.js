(function() {
  Backbone.history = new Backbone.History;
  jQuery(function($) {
    new LDB.DashboardController();
    return Backbone.history.start();
  });
}).call(this);
