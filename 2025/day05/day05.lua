require 'input-reader'

-- local input = Read_File 'day05/example.txt'
local input = Read_File 'day05/input.txt'

-- PART 1

local fresh_ids = 0
local ranges_1 = {}
local ids = {}
for _, line in ipairs(input) do
  if string.find(line, '-') then
    local range = {}
    for val in string.gmatch(line, '([^-]+)') do
      table.insert(range, tonumber(val))
    end
    table.insert(ranges_1, range)
  elseif #line > 0 then
    table.insert(ids, tonumber(line))
  end
end

for _, id in ipairs(ids) do
  for _, range in ipairs(ranges_1) do
    if range[1] <= id and id <= range[2] then
      fresh_ids = fresh_ids + 1
      goto next_id
    end
  end
  ::next_id::
end

print('part 1: ', fresh_ids)

-- PART 2

local fresh_ids_2 = 0
local ranges_2 = {}
for _, line in ipairs(input) do
  if string.find(line, '-') then
    local new_range = {}
    for val in string.gmatch(line, '([^-]+)') do
      table.insert(new_range, tonumber(val))
    end

    table.insert(ranges_2, new_range)
  end
end

table.sort(ranges_2, function(a, b)
  return a[1] < b[1]
end)

-- consolidate ranges in list
::restart::

for a_i, range_a in ipairs(ranges_2) do
  for b_i, range_b in ipairs(ranges_2) do
    if a_i == b_i then
      goto continue
    end
    -- new range is between both existing range [ { } ] -> ditch new range
    if range_a[1] <= range_b[1] and range_b[2] <= range_a[2] then
      table.remove(ranges_2, b_i)
      goto restart

      -- new range starts within existing range but ends beyond it [ { ] } -> extend old range end to new range end [ {   ]
    elseif range_a[1] <= range_b[1] and range_b[1] <= range_a[2] then
      range_a[2] = range_b[2]
      table.remove(ranges_2, b_i)
      goto restart

      -- new range starts outside existing range but ends within it { [ } ] -> extend old range start to new range start [   } ]
    elseif range_b[1] <= range_a[1] and range_a[1] <= range_b[2] then
      range_a[1] = range_b[1]
      table.remove(ranges_2, b_i)
      goto restart

      -- new range starts before existing range but ends after it { [ ] } -> change old range to be new range
    elseif range_b[1] <= range_a[1] and range_a[2] <= range_b[2] then
      table.remove(ranges_2, a_i)
      goto restart
    end
    ::continue::
  end
end

for _, range in ipairs(ranges_2) do
  fresh_ids_2 = fresh_ids_2 + (range[2] - range[1] + 1)
end

print('part 2: ', fresh_ids_2)
