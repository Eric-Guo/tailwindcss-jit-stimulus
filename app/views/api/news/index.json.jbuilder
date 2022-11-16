json.total @total
json.list @list do |news|
  json.id news.id
  json.title news.title
  json.subtitle news.subtitle
  json.cover mat_img_url(news.cover)
  json.url news.url
  json.published_at news.published_at&.strftime('%Y-%m-%d %H:%M:%S')
  tags = []
  if news.source.present?
    tags << news.source
  end
  news.materials.each do |material|
    tags << material.name
  end
  json.tags tags
end
