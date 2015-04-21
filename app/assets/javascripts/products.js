(function($) {
  
  var ready = function() {
    // Clear out the error highlighting if we've changed the field.
    $("input[name*='product']", ".field_with_errors").change(function(event) {
      $(this.closest('div.form-group').children).removeClass("field_with_errors")
    });

    $("#select_all").change(function(event) {
      $(":checkbox[name*='selectable']").prop('checked', this.checked);
      return false;
    });

    $("#delete-bulk").click(function(event) {
      delete_bulk();
    });
    
    $(":checkbox[name*='selectable']").change(function() {
      $(":checkbox[id='select_all']").prop('checked', false);
    })
  };
  //
  // TODO: Allow for commas in the numbers (filter them out)

  //http://stackoverflow.com/questions/17600093/rails-javascript-not-loading-after-clicking-through-link-to-helper
  // Compatability for regular pages.
  $(document).ready(ready);

  // Rails 4.0 uses Turbolinks so we use on>page:load
  $(document).on('page:load', ready);

  function delete_bulk()  {
    var to_be_deleted  = $(":checkbox[name*='selectable']:checked").map(function() { return $(this).data("id") }).get();
    
    var request = $.ajax({
      url: "/products/destroy_bulk",
      dataType: "json",
      type: "delete",
      data: {ids: to_be_deleted}
    });

    request.success(function(result, textStatus, jqXHR) {
      // Get all rows. Probably don't need this but keeping for reference.
      // var rows = $("*[class^='row_']")
      $('#notice #notice-message').html(result.message.join("<br>"));
      $('#notice').show();

      
      //Remove the products from the list in a pretty/animated way.
      // rocking the old school native js way instead of using $.each
      for (i=0; i < to_be_deleted.length; i++) {
        var row = $("*[class^='row-" + to_be_deleted[i] + "']");
        $(row).fadeOut( "slow", function() {
          $(this).remove();
        });
      }

      $('#notice').fadeOut(5000, function() {
        if ($(".pagination") && $("table#products tr").length == 1) {
          $('#notice #notice-message').html("Reload the page to update the pagination.");
          $('#notice').show();
        }
      });
      
      // Uncheck the select all checkbox in case it's checked.
      $(":checkbox[id='select_all']").prop('checked', false);
    });
  }

})(jQuery);


