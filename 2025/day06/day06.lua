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
print()

-- PART 2

local transposed = {}
for col = #input[1], 1, -1 do
  local line = ''
  for row = 1, #input do
    local char = string.sub(input[row], col, col)

    if char ~= '*' and char ~= '+' then
      line = line .. char
    end
  end
  table.insert(transposed, line)
end

-- example transposed
--   4
-- 431
-- 623
--
-- 175
-- 581
--  32
--
-- 8
-- 248
-- 369
--
-- 356
-- 24
-- 1

local total_2 = 0
local equation = #operations
local operation = operations[equation]
local equation_val = 0

if operation == '*' then
  equation_val = 1
end

for _, raw_val in ipairs(transposed) do
  if raw_val:match '^ *(.-) *$' == '' then
    equation = equation - 1
    operation = operations[equation]

    total_2 = total_2 + equation_val

    if operation == '*' then
      equation_val = 1
    else
      equation_val = 0
    end
  else
    if operation == '*' then
      equation_val = equation_val * tonumber(raw_val)
    else
      equation_val = equation_val + tonumber(raw_val)
    end
  end
end

total_2 = total_2 + equation_val

print('part 2:', total_2)
