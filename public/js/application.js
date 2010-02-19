(function($) {
  var app = $.sammy(function() {
    this.element_selector = '#content';

    this.before(function() {
      this.$element().append('<div class="loading">Loading...</div>');
    });

    this.get('#/', function() {
      Layout.get('/p.js');
    });

    this.get('#/p/:id', function() {
      Layout.get('/p/' + this.params['id'] + '.js');
    });
  });

  $(function() { app.run('#/'); });
})(jQuery);
