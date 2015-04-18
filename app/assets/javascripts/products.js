(function($) {
  
  var ready = function() {
    // Clear out the error highlighting if we've changed the field.
    $("input[name*='product']", ".field_with_errors").change(function(event) {
      $(this.closest('div.form-group').children).removeClass("field_with_errors")
    })
  };
  
  // TODO: Allow for commas in the numbers (filter them out)
  
  //http://stackoverflow.com/questions/17600093/rails-javascript-not-loading-after-clicking-through-link-to-helper
  // Compatability for regular pages.
  $(document).ready(ready);

  // Rails 4.0 uses Turbolinks so we use on>page:load
  $(document).on('page:load', ready);
  
})(jQuery);


