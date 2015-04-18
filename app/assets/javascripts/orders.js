(function($) {
  
  var ready = function() {
    // Clear out the error highlighting if we've changed the field.
    $("input[name*='order']", ".field_with_errors").change(function(event) {
      $(this.closest('div.form-group').children).removeClass("field_with_errors")
    });
    
    // $("#order_form").submit(function(event) {
//       // Validate Address
//
//     });
    
    // $('#order_product').bind('railsAutocomplete.select', function(event, data){
//       /* Do something here */
//       alert(data.item.id);
//     });
  };
  
  
  
  
  //http://stackoverflow.com/questions/17600093/rails-javascript-not-loading-after-clicking-through-link-to-helper
  // Compatability for regular pages.
  $(document).ready(ready);

  // Rails 4.0 uses Turbolinks so we use on>page:load
  $(document).on('page:load', ready);
  
})(jQuery);


