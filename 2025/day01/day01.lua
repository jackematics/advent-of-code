require 'input-reader'

-- local input = Read_File 'day01/example.txt'
local input = Read_File 'day01/input.txt'

-- PART 1

local dial_val = 50
local zero_count = 0
for _, rotation in ipairs(input) do
  local dir = string.sub(rotation, 1, 1)
  local val = tonumber(string.sub(rotation, 2))

  if dir == 'L' then
    val = val * -1
  end

  dial_val = (dial_val + val) % 100

  if dial_val == 0 then
    zero_count = zero_count + 1
  end
end

print('part 1: ', zero_count)
print ''

-- PART 2

local dial_val_2 = 50
local zero_click_count = 0

for _, rotation in ipairs(input) do
  local dir = string.sub(rotation, 1, 1)
  local val = tonumber(string.sub(rotation, 2))

  local sign = 1
  if dir == 'L' then
    sign = -1
  end

  if val == 0 then
    goto continue
  end

  local after_rotation = dial_val_2 + val * sign
  if after_rotation <= 0 or 100 <= after_rotation then
    zero_click_count = zero_click_count + math.floor((after_rotation * sign) / 100)

    if after_rotation <= 0 and dial_val_2 ~= 0 then
      zero_click_count = zero_click_count + 1
    end
  end

  dial_val_2 = after_rotation % 100
  print()
  ::continue::
end

print('part 2: ', zero_click_count)
