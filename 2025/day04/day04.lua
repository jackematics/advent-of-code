require 'input-reader'

-- local input = Read_File 'day04/example.txt'
local input = Read_File 'day04/input.txt'

-- PART 1

local accessible_paper_count = 0
for row, _ in ipairs(input) do
  for col = 1, #input[row] do
    if string.sub(input[row], col, col) ~= '@' then
      goto next_col
    end

    local adjacent_indices = {
      { row = row - 1, col = col - 1 },
      { row = row - 1, col = col },
      { row = row - 1, col = col + 1 },
      { row = row, col = col + 1 },
      { row = row + 1, col = col + 1 },
      { row = row + 1, col = col },
      { row = row + 1, col = col - 1 },
      { row = row, col = col - 1 },
    }

    local adjacent_rolls = 0
    for i = 1, #adjacent_indices do
      local adj_row, adj_col = adjacent_indices[i].row, adjacent_indices[i].col

      if adj_row < 1 or adj_row > #input[row] or adj_col < 1 or adj_col > #input[row] then
        goto continue
      end

      if string.sub(input[adj_row], adj_col, adj_col) == '@' then
        adjacent_rolls = adjacent_rolls + 1
      end

      ::continue::
    end

    if adjacent_rolls < 4 then
      accessible_paper_count = accessible_paper_count + 1
    end

    ::next_col::
  end
end

print('part 1:', accessible_paper_count)

-- PART 2

local removed_paper_count = 0

local removable_indices = {}
repeat
  for _, rowcol in ipairs(removable_indices) do
    input[rowcol.row] = string.sub(input[rowcol.row], 1, rowcol.col - 1) .. '.' .. string.sub(input[rowcol.row], rowcol.col + 1)
    removed_paper_count = removed_paper_count + 1
  end

  -- for _, i in ipairs(input) do
  --   print(i)
  -- end
  -- print()

  -- for _, i in ipairs(removable_indices) do
  -- end
  -- print()

  removable_indices = {}

  for row, _ in ipairs(input) do
    for col = 1, #input[row] do
      if string.sub(input[row], col, col) ~= '@' then
        goto next_col
      end

      local adjacent_indices = {
        { row = row - 1, col = col - 1 },
        { row = row - 1, col = col },
        { row = row - 1, col = col + 1 },
        { row = row, col = col + 1 },
        { row = row + 1, col = col + 1 },
        { row = row + 1, col = col },
        { row = row + 1, col = col - 1 },
        { row = row, col = col - 1 },
      }

      local adjacent_rolls = 0
      for i = 1, #adjacent_indices do
        local adj_row, adj_col = adjacent_indices[i].row, adjacent_indices[i].col

        if adj_row < 1 or adj_row > #input[row] or adj_col < 1 or adj_col > #input[row] then
          goto continue
        end

        if string.sub(input[adj_row], adj_col, adj_col) == '@' then
          adjacent_rolls = adjacent_rolls + 1
        end

        ::continue::
      end

      if adjacent_rolls < 4 then
        table.insert(removable_indices, { row = row, col = col })
      end

      ::next_col::
    end
  end

until #removable_indices == 0

print('part 2:', removed_paper_count)
