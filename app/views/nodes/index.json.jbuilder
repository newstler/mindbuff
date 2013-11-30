json.array!(@nodes) do |node|
  json.extract! node, :link
  json.url node_url(node, format: :json)
end
