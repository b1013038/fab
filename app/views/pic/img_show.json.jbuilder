json.array!(@img) do |img|
  json.extract! img, :id, :category, URI.escape(:filedata)
end