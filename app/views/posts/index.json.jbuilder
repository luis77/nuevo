json.array!(@posts) do |post|
  json.extract! post, :id, :titulo, :contenido, :extension, :usuario_id
  json.url post_url(post, format: :json)
end
