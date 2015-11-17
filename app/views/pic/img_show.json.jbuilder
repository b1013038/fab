json.array!(@img) do |img|
  json.extract! img, :id, :category, :filedata
end