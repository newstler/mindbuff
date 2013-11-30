json.array!(@nodes) do |node|
  json.success true
  json.nodes @nodes.collect{ |n| n.node_for_json }
end.to_json