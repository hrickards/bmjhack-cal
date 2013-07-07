//= require fullcalendar
//= require jquery.markitup
//= require set

function loadPage() {
  window.courses = $('#event_course_list').val();
  window.years = $('#event_year_list').val();
  window.tags = $('#event_tag_list').val();

  $('#calendar').fullCalendar({
    events: function(start, end, callback) {
      $.ajax({
        url: 'events.json',
        dataType: 'json',
        data: {
          start: start.toISOString(),
          end: end.toISOString(),
          courses: courses,
          years: years,
          tags: tags
        },
        success: function(doc) {
          callback(doc);
        }
      });
    }
  });

  $('#event_course_list').change(function() {
    courses = $(this).val();
    filterResults();
  });
  $('#event_year_list').change(function() {
    years = $(this).val();
    filterResults();
  });
  $('#event_tag_list').change(function() {
    tags = $(this).val();
    filterResults();
  });

  function filterResults() {
    $('#calendar').fullCalendar('refetchEvents');
  }

  $("#event_resources").markItUp(mySettings);

  $('#start_datetime').datetimepicker({
    language: 'en'
  });
}

document.addEventListener("page:load", loadPage);
$(document).ready(loadPage);
