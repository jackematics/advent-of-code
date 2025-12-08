require 'input-reader'

-- local input = Read_File 'day07/example.txt'
local input = Read_File 'day07/input.txt'

local function contains_grid_ref(array, val)
  for _, arr_val in ipairs(array) do
    if val.row == arr_val.row and val.col == arr_val.col then
      return true
    end
  end

  return false
end

-- PART 1

local s_0 = { row = 1, col = string.find(input[1], 'S') }
local timeline_count = 0
local covered = {}

local function emit_beam(s_i)
  if contains_grid_ref(covered, s_i) then
    return
  end

  if string.sub(input[s_i.row], s_i.col, s_i.col) == '^' then
    timeline_count = timeline_count + 1

    local left = { row = s_i.row, col = s_i.col - 1 }
    local right = { row = s_i.row, col = s_i.col + 1 }

    if not contains_grid_ref(covered, left) then
      emit_beam(left)
    end

    if not contains_grid_ref(covered, right) then
      emit_beam(right)
    end
    return
  end

  table.insert(covered, s_i)

  if s_i.row == #input then
    return
  end

  emit_beam { row = s_i.row + 1, col = s_i.col }
end

emit_beam(s_0)

print('part 1', timeline_count)

-- PART 2

local col_counter = {}
local row_mid = string.find(input[1], 'S')

for col = 1, #input[1] do
  if string.sub(input[1], col, col) ~= 'S' then
    table.insert(col_counter, 0)
  else
    table.insert(col_counter, 1)
  end
end

local splits = 0
local i, col, col_end = 3, row_mid, row_mid + 1
while i < #input do
  for j = col, col_end do
    if string.sub(input[i], j, j) == '^' and col_counter[j] ~= 0 then
      splits = splits + 1
      col_counter[j - 1] = col_counter[j - 1] + col_counter[j]
      col_counter[j + 1] = col_counter[j + 1] + col_counter[j]
      col_counter[j] = 0
    end
  end

  i = i + 2
  col = col - 1
  col_end = col_end + 1
end

timeline_count = 0

for _, count in ipairs(col_counter) do
  timeline_count = timeline_count + count
end

print('part 2', timeline_count)
