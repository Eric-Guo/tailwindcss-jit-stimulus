json.states @states do |key, value|
  json.label value[:title]
  json.value key
end
