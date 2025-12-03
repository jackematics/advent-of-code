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

  local b_index = a_index + 1
  local battery_b = tonumber(string.sub(bank, b_index, b_index))
  for i = b_index, #bank do
    local battery = tonumber(string.sub(bank, i, i))
    if battery > battery_b then
      battery_b = battery
      b_index = i
    end
  end

  local joltage = tonumber(tostring(battery_a) .. tostring(battery_b))

  output_joltage = output_joltage + joltage
end

print('part 1:', output_joltage)

-- PART 1

local output_joltage_2 = 0

for _, bank in ipairs(input) do
  local batteries = ''

  local best_i = 1

  for limit = 11, 0, -1 do
    local best_bat = tonumber(string.sub(bank, best_i, best_i))

    for i = best_i, #bank - limit do
      local battery = tonumber(string.sub(bank, i, i))

      if battery > best_bat then
        best_bat = battery
        best_i = i
      end
    end

    best_i = best_i + 1

    batteries = batteries .. tostring(best_bat)
  end

  output_joltage_2 = output_joltage_2 + tonumber(batteries)
end

print('part 2:', output_joltage_2)
