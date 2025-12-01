function Read_File(path)
  local file = io.open(path, 'rb')
  if file == nil then
    return {}
  end
  file:close()

  local lines = {}
  for line in io.lines(path) do
    lines[#lines + 1] = line
  end

  return lines
end
