(function() {
  Backbone.history = new Backbone.History;
  jQuery(function($) {
    FDB.rootView = new FDB.ApplicationView();
    FDB.rootView.render();
    $('#application').append(FDB.rootView.el);
    new FDB.DashboardController();
    new FDB.FilesController();
    new FDB.SecretEditController();
    Backbone.history.start();
    return $('.flash').each(function(e) {
      FDB.notify({
        message: this.innerHTML,
        icon: "ui-icon-" + ($(this).attr('class').split(' ')[0])
      });
      return $(this).remove();
    });
  });
}).call(this);
