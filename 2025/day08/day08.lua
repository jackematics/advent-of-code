require 'input-reader'

-- local input = Read_File 'day08/example.txt'
local input = Read_File 'day08/input.txt'

-- PART 1 BRUTE FORCE

local function table_contains(table, element)
  for _, el in ipairs(table) do
    if el == element then
      return true
    end
  end

  return false
end

local function get_distance(a_raw, b_raw)
  local a = {}
  for coord in string.gmatch(a_raw, '([^,]+)') do
    table.insert(a, tonumber(coord))
  end

  local b = {}
  for coord in string.gmatch(b_raw, '([^,]+)') do
    table.insert(b, tonumber(coord))
  end

  return math.sqrt((b[1] - a[1]) ^ 2 + (b[2] - a[2]) ^ 2 + (b[3] - a[3]) ^ 2)
end

local distances = {}
for i = 1, #input do
  for j = i + 1, #input do
    table.insert(distances, { a = input[i], b = input[j], distance = get_distance(input[i], input[j]) })
  end
end

table.sort(distances, function(a, b)
  return a.distance < b.distance
end)

local circuits = {}

local connection_count = 0
local d_i = 1
while connection_count < 10 do
  local a_circuit_index = nil
  local b_circuit_index = nil
  for i, circuit in ipairs(circuits) do
    for _, junction in ipairs(circuit) do
      if junction == distances[d_i].a then
        a_circuit_index = i
      end

      if junction == distances[d_i].b then
        b_circuit_index = i
      end
    end
  end

  -- pull lonely junction b into circuit where a lives
  if a_circuit_index ~= nil and b_circuit_index == nil then
    table.insert(circuits[a_circuit_index], distances[d_i].b)
    connection_count = connection_count + 1
    -- pull lonely junction a into circuit where b lives
  elseif a_circuit_index == nil and b_circuit_index ~= nil then
    table.insert(circuits[b_circuit_index], distances[d_i].a)
    connection_count = connection_count + 1
  -- create new circuit for two lonely junctions
  elseif a_circuit_index == nil and b_circuit_index == nil then
    table.insert(circuits, { distances[d_i].a, distances[d_i].b })
    connection_count = connection_count + 1
  -- circuits in same junction
  elseif a_circuit_index == b_circuit_index and a_circuit_index ~= nil then
    connection_count = connection_count + 1
  -- combine circuits
  elseif a_circuit_index ~= b_circuit_index and a_circuit_index ~= nil then
    for _, junction in ipairs(circuits[b_circuit_index]) do
      if not table_contains(circuits[a_circuit_index], junction) then
        table.insert(circuits[a_circuit_index], junction)
      end
    end

    table.remove(circuits, b_circuit_index)
    connection_count = connection_count + 1
  end

  d_i = d_i + 1
end

table.sort(circuits, function(a, b)
  return #a > #b
end)

local three_largest_circuits_product = 1
for i = 1, 3 do
  three_largest_circuits_product = three_largest_circuits_product * #circuits[i]
end

print('part 1:', three_largest_circuits_product)

-- PART 1 Minimum Spanning Tree Algorithm (Prims)

-- local priority_queue = {}
-- local tree = {}
--
-- for i = 1, #input do
--   table.insert(tree, {})
--   for j = 1, #input do
--     if i ~= j then
--       table.insert(tree[i], { start = input[i], dest = input[j], dist = getDistance(input[i], input[j]) })
--     else
--       table.insert(tree[i], { start = input[i], dest = input[j], dist = 0 })
--     end
--   end
-- end
--
-- local visited = {}
-- for _ = 1, #input do
--   table.insert(visited, false)
-- end
--
-- local function add_edges(node)
--   local node_index = nil
--   for i = 1, #input do
--     if input[i] == node then
--       node_index = i
--       break
--     end
--   end
--
--   if node_index == nil then
--     error("Couldn't find node index:", node)
--   end
--
--   visited[node_index] = true
--
--   local edges = tree[node_index]
--   for _, edge in ipairs(edges) do
--     if not visited[edge.start] then
--       table.insert(priority_queue, edge)
--     end
--   end
-- end
--
-- local current_node = input[1]
-- local function lazy_prims()
--   local m = #input - 1
--   local edge_count, mst_cost = 1, 0
--   local mst_edges = {}
--   for _ = 1, m do
--     table.insert(mst_edges, {})
--   end
--
--   add_edges(current_node)
--
--   while #priority_queue > 0 and edge_count ~= m do
--     print(edge_count)
--     local edge = table.remove(priority_queue, 1)
--     local node_index = edge.dest
--
--     if visited[node_index] then
--       goto continue
--     end
--
--     mst_edges[edge_count] = edge
--     edge_count = edge_count + 1
--     mst_cost = mst_cost + edge.dist
--
--     add_edges(node_index)
--
--     ::continue::
--   end
--
--   return mst_cost, mst_edges
-- end
--
-- local _, edges = lazy_prims()
--
-- print('part 1', edges[1] * edges[2] * edges[3])
