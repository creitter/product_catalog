(function($) {
  
  var ready = function() {
  };
  
  
  //http://stackoverflow.com/questions/17600093/rails-javascript-not-loading-after-clicking-through-link-to-helper
  // Compatability for regular pages.
  $(document).ready(ready);

  // Rails 4.0 uses Turbolinks so we use on>page:load
  $(document).on('page:load', ready);
  
})(jQuery);