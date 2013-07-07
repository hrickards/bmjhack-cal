json.extract! @event, :title, :location, :teacher, :no_remaining_spaces, :duration
json.start @event.start_datetime.iso8601
