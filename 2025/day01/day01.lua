require 'input-reader'

local input = Read_File 'day01/input.txt'

-- PART 1

local dial_val = 50
local zero_count = 0
for _, rotation in ipairs(input) do
  local dir = string.sub(rotation, 1, 1)
  local val = tonumber(string.sub(rotation, 2))
  print('dir: ', dir)
  print('val: ', val)

  if dir == 'L' then
    dial_val = (dial_val - val) % 100
  else
    dial_val = (dial_val + val) % 100
  end

  print('dial_val: ', dial_val)

  if dial_val == 0 then
    zero_count = zero_count + 1
  end
end

print(zero_count)
