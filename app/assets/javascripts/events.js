//= require fullcalendar
//= require jquery.markitup
//= require set
//= require strftime
//= require jquery.ui.all
//= require tag-it


function formatStart(datestring) {
  var date = new Date(datestring);
  return date.strftime("%b %d, %H:%m");
}

function loadPage() {
  window.courses = $('#event_course_list').val();
  window.years = $('#event_year_list').val();
  window.tags = $('#event_tag_list').val();
  window.types = $('#event_type_list').val();

  $('#calendar').fullCalendar({
    aspectRatio: 1.28,
    eventMouseover: function(event, jsEvent, view) {
      $.ajax({
        url: 'event.json',
        dataType: 'json',
        data: { id: event['id'] },
        success: function(doc) {
          var html = "<h4>" + doc['title'] + "</h4><h5>" + formatStart(doc['start']) + "</h5><h5>" + doc['duration'] + " minutes</h5><h6>" + doc['teacher'] + ", " + doc['location'] + "</h6><h6>" + doc['no_remaining_spaces'] + " remaining spaces</h6>";
          $('#event_details').html(html);
        }
      });
    },
    events: function(start, end, callback) {
      $.ajax({
        url: 'events.json',
        dataType: 'json',
        data: {
          start: start.toISOString(),
          end: end.toISOString(),
          courses: courses,
          years: years,
          tags: tags,
          types: types
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
  $('#event_type_list').change(function() {
    types = $(this).val();
    filterResults();
  });

  function filterResults() {
    $('#calendar').fullCalendar('refetchEvents');
  }

  $("#event_resources").markItUp(mySettings);

  $('#start_datetime').datetimepicker({
    language: 'en'
  });

  $("#event_keywords").tagit();
}

document.addEventListener("page:load", loadPage);
$(document).ready(loadPage);
