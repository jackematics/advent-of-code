require 'input-reader'

-- local input = Read_File 'day03/example.txt'
local input = Read_File 'day03/input.txt'

-- PART 1

local output_joltage = 0
for _, bank in ipairs(input) do
  local a_index = 1
  local battery_a = tonumber(string.sub(bank, a_index, a_index))
  for i = 1, #bank - 1 do
    local battery = tonumber(string.sub(bank, i, i))
    if battery > battery_a then
      battery_a = battery
      a_index = i
    end
  end

  print('a', battery_a)

  local b_index = a_index + 1
  local battery_b = tonumber(string.sub(bank, b_index, b_index))
  for i = b_index, #bank do
    local battery = tonumber(string.sub(bank, i, i))
    if battery > battery_b then
      battery_b = battery
      b_index = i
    end
  end

  print('b', battery_b)

  local joltage = tonumber(tostring(battery_a) .. tostring(battery_b))

  output_joltage = output_joltage + joltage

  print('joltage:', output_joltage)
  print()
end

print('part 1:', output_joltage)
