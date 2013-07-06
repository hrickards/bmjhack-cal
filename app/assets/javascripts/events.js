//= require fullcalendar

$(document).ready(function() {
  $('#calendar').fullCalendar({
    events: "./events.json"
  });
});
