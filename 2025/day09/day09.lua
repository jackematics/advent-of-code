require 'input-reader'

-- local input = Read_File 'day09/example.txt'
local input = Read_File 'day09/input.txt'

-- PART 1

local red_tiles = {}

for _, raw_grid_ref in ipairs(input) do
  local split = string.gmatch(raw_grid_ref, '([^,]+)')
  table.insert(red_tiles, { col = tonumber(split()) + 1, row = tonumber(split()) + 1 })
end

local function area(a, b)
  return (math.abs(b.row - a.row) + 1) * (math.abs(b.col - a.col) + 1)
end

local largest_area = 0
for i = 1, #red_tiles do
  for j = i + 1, #red_tiles do
    local a = red_tiles[i]
    local b = red_tiles[j]

    local current_area = area(a, b)
    if current_area > largest_area then
      largest_area = current_area
    end
  end
end

print('part 1:', largest_area)

-- PART 2

local function intersect(horizontal_edges, vertical_edges)
  for _, hor_edge in ipairs(horizontal_edges) do
    local hcol_0 = math.min(hor_edge[1].col, hor_edge[2].col)
    local hcol_max = math.max(hor_edge[1].col, hor_edge[2].col)
    local hrow = hor_edge[1].row

    for _, ver_edge in ipairs(vertical_edges) do
      local vrow_0 = math.min(ver_edge[1].row, ver_edge[2].row)
      local vrow_max = math.max(ver_edge[1].row, ver_edge[2].row)
      local vcol = ver_edge[1].col

      if (vrow_0 <= hrow and hrow <= vrow_max) and (hcol_0 <= vcol and vcol <= hcol_max) then
        return true
      end
    end
  end

  return false
end

local red_tiles_boundary = {}
for i = 1, #red_tiles do
  local prev
  local next
  if i ~= 1 then
    prev = red_tiles[i - 1]
  else
    prev = red_tiles[#red_tiles]
  end

  if i ~= #red_tiles then
    next = red_tiles[i + 1]
  else
    next = red_tiles[1]
  end

  local row = red_tiles[i].row
  local col = red_tiles[i].col

  if (prev.row > row and next.col > col) or (prev.col < col and next.row < row) then
    table.insert(red_tiles_boundary, { row = row - 0.25, col = col - 0.25 })
  elseif (prev.col > col and next.row < row) or (prev.row > row and next.col < col) then
    table.insert(red_tiles_boundary, { row = row + 0.25, col = col - 0.25 })
  elseif prev.col < col and next.row > row or (prev.row < row and next.col > col) then
    table.insert(red_tiles_boundary, { row = row - 0.25, col = col + 0.25 })
  elseif (prev.row < row and next.col < col) or (prev.col > col and next.row > row) then
    table.insert(red_tiles_boundary, { row = row + 0.25, col = col + 0.25 })
  else
    print 'ya fucked up kid'
  end
end

local largest_area_2 = 0
local horizontal_edges = {}
local vertical_edges = {}
for i = 1, #red_tiles_boundary do
  local edge
  if i ~= #red_tiles_boundary then
    edge = { red_tiles_boundary[i], red_tiles_boundary[i + 1] }
  else
    edge = { red_tiles_boundary[i], red_tiles_boundary[1] }
  end

  if edge[1].row == edge[2].row then
    table.insert(horizontal_edges, edge)
  else
    table.insert(vertical_edges, edge)
  end
end

for i = 1, #red_tiles do
  for j = i + 1, #red_tiles do
    local a = red_tiles[i]
    local b = red_tiles[j]

    local rect_horizontal_edges = {
      { { row = a.row, col = a.col }, { row = a.row, col = b.col } },
      { { row = b.row, col = b.col }, { row = b.row, col = a.col } },
    }

    local rect_vertical_edges = {
      { { row = a.row, col = a.col }, { row = b.row, col = a.col } },
      { { row = b.row, col = b.col }, { row = a.row, col = b.col } },
    }

    if intersect(rect_horizontal_edges, vertical_edges) or intersect(horizontal_edges, rect_vertical_edges) then
      goto continue
    end

    local current_area = area(a, b)
    if current_area > largest_area_2 then
      largest_area_2 = current_area
    end
    ::continue::
  end
end

print('part 2:', largest_area_2)
