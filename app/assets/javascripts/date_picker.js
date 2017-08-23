document.addEventListener("turbolinks:load", function() {
  $(function () {
      $('#event_time_date').datetimepicker({
          inline: true,
          sideBySide: true,
          format: 'YYYY-MM-DD hh:mm A Z'
      });
  });
})