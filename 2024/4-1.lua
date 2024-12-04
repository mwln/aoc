local xmas_count = 0
local grid = {}

for line in io.lines("input.txt") do
    local row = {}
    for char in line:gmatch(".") do
        table.insert(row, char)
    end
    table.insert(grid, row)
end

local width = #grid[1]
local height = #grid

local function at(x, y)
    if (x > width or x < 1) then return "-" end
    if (y > height or y < 1) then return "-" end

    return grid[y][x]
end

local offsets = {
    { -1, 0 },
    { 1,  0 },
    { 0,  -1 },
    { 0,  1 },
    { -1, -1 },
    { 1,  -1 },
    { -1, 1 },
    { 1,  1 }
}

local function search(x, y)
    local target = "XMAS"
    local hits = 0
    for _, offset in ipairs(offsets) do
        local cx, cy = x, y
        local word = at(cx, cy)
        while target:sub(1, #word) == word and #target > #word do
            cx, cy = offset[1] + cx, offset[2] + cy
            word = word .. at(cx, cy)
        end
        hits = hits + (word == target and 1 or 0)
    end
    return hits
end

for y, row in ipairs(grid) do
    for x, cell in ipairs(row) do
        if cell == "X" then
            xmas_count = xmas_count + search(x, y)
        end
    end
end

print(xmas_count)
