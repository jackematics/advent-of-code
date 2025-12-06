require 'input-reader'

-- local input = Read_File 'day06/example.txt'
local input = Read_File 'day06/input.txt'

-- PART 1

local equations = {}
local operations = {}

for row = 1, #input do
  local i = 1
  local col = 1
  while i <= #input[row] do
    local char = string.sub(input[row], i, i)
    if char == ' ' then
      i = i + 1
    else
      local next_whitespace = string.find(input[row], ' ', i)
      if next_whitespace == nil then
        next_whitespace = #input[row] + 1
      end

      local element = string.sub(input[row], i, next_whitespace - 1)

      if row == 1 then
        table.insert(equations, { element })
      elseif row == #input then
        table.insert(operations, string.sub(input[row], i, i))
      else
        table.insert(equations[col], element)
        col = col + 1
      end

      i = next_whitespace
    end
  end
end

-- for row = 1, #equations do
--   for col = 1, #equations[row] do
--     print(equations[row][col])
--   end
--   print()
-- end
--
-- for i = 1, #operations do
--   print(operations[i])
-- end

local total = 0
for i, equation in ipairs(equations) do
  local operation = operations[i]

  local row_aggregate = 0
  if operation == '*' then
    row_aggregate = 1
  end

  for _, operand in ipairs(equation) do
    if operation == '*' then
      row_aggregate = row_aggregate * operand
    else
      row_aggregate = row_aggregate + operand
    end
  end
  total = total + row_aggregate
end

print('part 1:', total)
