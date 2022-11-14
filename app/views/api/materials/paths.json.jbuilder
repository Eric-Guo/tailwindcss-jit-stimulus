paths = []

case @material.level
when 1
  paths.push({
    id: @material.id,
    title: @material.name,
  })
when 2
  paths.push({
    id: @material.parent_material.id,
    title: @material.parent_material.name,
  })
  paths.push({
    id: @material.id,
    title: @material.name,
  })
when 3
  paths.push({
    id: @material.grandpa_material.id,
    title: @material.grandpa_material.name,
  })
  paths.push({
    id: @material.parent_material.id,
    title: @material.parent_material.name,
  })
  paths.push({
    id: @material.id,
    title: @material.name,
  })
end

json.array! paths
