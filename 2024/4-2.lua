local x_mas_count = 0
local grid = {}

for line in io.lines("input.txt") do
    line = line:gsub("X", ".")
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
    {
        { -1, 1 },
        { 1,  -1 }
    },
    {
        { -1, -1 },
        { 1,  1 }
    }
}

local function hits_target(str)
    if #str > 3 then return false end
    if str:sub(1, 1) ~= "A" then return false end
    if str:find("MM") or str:find("SS") then return false end
    return str:match("^A[MS]*$") ~= nil
end

local function valid_x_mas(x, y)
    for _, diagonal_offsets in ipairs(offsets) do
        local word = at(x, y)
        for _, offset in ipairs(diagonal_offsets) do
            word = word .. at(x + offset[1], y + offset[2])
            if not hits_target(word) then return false end
        end
    end
    return true
end

for y, row in ipairs(grid) do
    for x, cell in ipairs(row) do
        if cell == "A" then
            x_mas_count = x_mas_count + (valid_x_mas(x, y) and 1 or 0)
        end
    end
end

print(x_mas_count)
