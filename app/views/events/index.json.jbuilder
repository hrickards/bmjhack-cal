json.array!(@events) do |event|
  json.extract! event, :id, :title
  json.allDay false
  json.start event.start_datetime.iso8601
  json.end event.end_datetime.iso8601
  json.url event_url(event, format: :html)
  json.color event.color
  json.editable false
end
