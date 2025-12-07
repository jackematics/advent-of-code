require 'input-reader'

-- local input = Read_File 'day07/example.txt'
local input = Read_File 'day07/input.txt'
--

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

s_0 = { row = 1, col = string.find(input[1], 'S') }
timeline_count = 1

local function emit_quantum_beam(s_i)
  if string.sub(input[s_i.row], s_i.col, s_i.col) == '^' then
    local left = { row = s_i.row, col = s_i.col - 1 }
    local right = { row = s_i.row, col = s_i.col + 1 }

    timeline_count = timeline_count + 1
    emit_quantum_beam(left)
    emit_quantum_beam(right)
    return
  end

  if s_i.row == #input then
    return
  end

  emit_quantum_beam { row = s_i.row + 1, col = s_i.col }
end

emit_quantum_beam(s_0)

print('part 2', timeline_count)
