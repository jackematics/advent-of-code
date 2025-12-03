require 'input-reader'

-- local input = Read_File 'day02/example.txt'
local input = Read_File 'day02/input.txt'

-- PART 1

local invalid_id_sum = 0
for id_range_raw in string.gmatch(input[1], '([^,]+)') do
  local range = {}
  for bound in string.gmatch(id_range_raw, '([^-]+)') do
    table.insert(range, tonumber(bound))
  end

  for val = range[1], range[2] do
    local val_str = tostring(val)
    local halfIndex = math.ceil(#val_str / 2)

    local firstHalf = string.sub(val_str, 1, halfIndex)
    local secondHalf = string.sub(val_str, halfIndex + 1, #val_str)

    if firstHalf == secondHalf and string.sub(firstHalf, 1, 1) ~= 0 then
      invalid_id_sum = invalid_id_sum + val
    end
  end
end

print('part 1:', invalid_id_sum)
print ''

-- PART 2

local invalid_id_sum_2 = 0
for id_range_raw in string.gmatch(input[1], '([^,]+)') do
  local range = {}
  for bound in string.gmatch(id_range_raw, '([^-]+)') do
    table.insert(range, tonumber(bound))
  end

  for val = range[1], range[2] do
    local val_str = tostring(val)
    local halfIndex = math.ceil(#val_str / 2)

    for i = 1, halfIndex do
      if #val_str % 2 == 1 then
        val_str = string.sub(val_str, 1, halfIndex) .. string.sub(val_str, halfIndex + 1, #val_str)
      end

      local seq_start = string.sub(val_str, 1, i)
      local multiples = math.floor(#val_str / #seq_start)
      local sequence = string.rep(seq_start, multiples)

      local withoutLeading0s = string.gsub(sequence, '^0+', '')
      if sequence == val_str and sequence == withoutLeading0s and val > 9 then
        invalid_id_sum_2 = invalid_id_sum_2 + val
        break
      end
    end
  end
end

print('part 2:', invalid_id_sum_2)
print ''
