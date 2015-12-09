json.array! @img do |img|
  json.id img.id
  json.filedata URI.escape(img.filedata)
  json.title img.title.split("_#{img.userid}_")[0]
end