json.array!(@events) do |event|
  json.extract! event, :title, :description, :limit, :date
  json.url event_url(event, format: :json)
end
