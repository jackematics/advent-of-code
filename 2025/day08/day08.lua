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
while connection_count < 1000 do
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
print()

-- PART 2 BRUTE FORCE

local function get_x(raw_junction)
  local coords = string.gmatch(raw_junction, '([^,]+)')

  return tonumber(coords())
end

local function missing_junctions(circuit, junctions)
  for _, junction in ipairs(junctions) do
    if not table_contains(circuit, junction) then
      return true
    end
  end

  return false
end

local circuits_2 = {}

local d_j = 1
repeat
  local a_circuit_index = nil
  local b_circuit_index = nil
  for i, circuit in ipairs(circuits_2) do
    for _, junction in ipairs(circuit) do
      if junction == distances[d_j].a then
        a_circuit_index = i
      end

      if junction == distances[d_j].b then
        b_circuit_index = i
      end
    end
  end

  -- pull lonely junction b into circuit where a lives
  if a_circuit_index ~= nil and b_circuit_index == nil then
    table.insert(circuits_2[a_circuit_index], distances[d_j].b)
    -- pull lonely junction a into circuit where b lives
  elseif a_circuit_index == nil and b_circuit_index ~= nil then
    table.insert(circuits_2[b_circuit_index], distances[d_j].a)
  -- create new circuit for two lonely junctions
  elseif a_circuit_index == nil and b_circuit_index == nil then
    table.insert(circuits_2, { distances[d_j].a, distances[d_j].b })
  -- circuits in same junction
  elseif a_circuit_index == b_circuit_index and a_circuit_index ~= nil then
  -- combine circuits
  elseif a_circuit_index ~= b_circuit_index and a_circuit_index ~= nil then
    for _, junction in ipairs(circuits_2[b_circuit_index]) do
      if not table_contains(circuits_2[a_circuit_index], junction) then
        table.insert(circuits_2[a_circuit_index], junction)
      end
    end

    table.remove(circuits_2, b_circuit_index)
  end

  d_j = d_j + 1
until #circuits_2 == 1 and not missing_junctions(circuits_2[1], input)

print('part 2:', get_x(distances[d_j - 1].a) * get_x(distances[d_j - 1].b))
