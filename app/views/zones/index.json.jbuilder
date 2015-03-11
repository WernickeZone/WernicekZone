json.array!(@zones) do |zone|
  json.extract! zone, :id, :title, :body, :published
  json.url zone_url(zone, format: :json)
end
