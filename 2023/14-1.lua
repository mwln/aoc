local map = {}
for line in io.lines("input.txt") do
    local row = {}
    for piece in line:gmatch(".") do
        table.insert(row, piece)
    end
    table.insert(map, row)
end

local pmap = { table.unpack(map) }

local function north(x, y)
    local n_north = y - 1
    local now = y
    while n_north > 0 do
        if pmap[n_north][x] ~= "." then
            break
        else
            pmap[now][x] = "."
            pmap[n_north][x] = "O"
            n_north = n_north - 1
            now = now - 1
        end
    end
    return now
end

local balance = #map + 1
local load = 0
for y, row in ipairs(map) do
    for x, item in ipairs(row) do
        if item == "O" then
            load = load + balance - north(x, y)
        end
    end
end
print(load)
