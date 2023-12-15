local map = {}
for line in io.lines("input.txt") do
    local row = {}
    for piece in line:gmatch(".") do
        table.insert(row, piece)
    end
    table.insert(map, row)
end

local pmap = { table.unpack(map) }

local function rotate(grid)
    local rotated_grid = {}
    for x = 1, #grid[1] do
        local row = {}
        for y = #grid, 1, -1 do
            table.insert(row, grid[y][x])
        end
        table.insert(rotated_grid, row)
    end
    return rotated_grid
end

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
end

local function north_beam_load(grid)
    local balance = #grid + 1
    local load = 0
    for y, row in ipairs(grid) do
        for _, item in ipairs(row) do
            if item == "O" then
                load = load + balance - y
            end
        end
    end
    return load
end

local function stringify(pos_map)
    local str = ""
    for _, row in ipairs(pos_map) do
        for _, item in ipairs(row) do
            str = str .. item
        end
    end
    return str
end

local function run_cycles(n)
    local loads = {}
    local cycles = {}
    local cycle = 1
    while cycle <= n do
        local rotations = 0
        while rotations < 4 do
            for y = 1, #map do
                for x = 1, #map[1] do
                    if pmap[y][x] == "O" then
                        north(x, y)
                    end
                end
            end
            pmap = rotate(pmap)
            rotations = rotations + 1
        end
        local cycle_start = cycles[stringify(pmap)]
        if cycle_start then
            return { table.unpack(loads, cycle_start, cycle) }, cycle_start, cycle
        else
            cycles[stringify(pmap)] = cycle
            table.insert(loads, north_beam_load(pmap))
            cycle = cycle + 1
        end
    end
end

local total = 1000000000
local loads, cycle_start, cycle_end = run_cycles(500)
local cycle_length = cycle_end - cycle_start
local load_index = (total - cycle_start + 1) % cycle_length
print(loads[load_index])
