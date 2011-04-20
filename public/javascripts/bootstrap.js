(function() {
  Backbone.history = new Backbone.History;
  jQuery(function($) {
    var fn, name, _ref;
    _ref = FDB.ViewRenderers;
    for (name in _ref) {
      fn = _ref[name];
      if (name.charAt(0) === "_" || name.indexOf("/_") !== -1) {
        Handlebars.registerPartial(name, fn);
      }
    }
    $('.flash').each(function(e) {
      FDB.notify({
        message: this.innerHTML,
        icon: "ui-icon-" + ($(this).attr('class').split(' ')[0])
      });
      return $(this).remove();
    });
    if ($('body').hasClass('application')) {
      FDB.rootView = new FDB.ApplicationView();
      FDB.rootView.render();
      $('#application').append(FDB.rootView.el);
      new FDB.DashboardController();
      new FDB.FilesController();
      new FDB.MoviesController();
      new FDB.SecretEditController();
      return Backbone.history.start();
    }
  });
}).call(this);
