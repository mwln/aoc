local maze = {}
local dmap = {}
local px, py = -1, -1
for line in io.lines("input.txt") do
    local row = {}
    table.insert(dmap, {})
    for tile in line:gmatch(".") do
        table.insert(row, tile)
        table.insert(dmap[#dmap], ".")
        if tile == "S" then
            px, py = #row, #maze + 1
        end
    end
    table.insert(maze, row)
end

local moves = { up = 1, down = 2, right = 3, left = 4 }
local started = false
local last_move = nil
local steps = 0
while true do
    local current = maze[py][px]
    dmap[py][px] = steps
    local down, left, right = nil, nil, nil
    if current == "S" then
        if started then
            break
        end
        started = true
        if px > 1 then
            left = maze[py][px - 1]
        end
        if py < #maze then
            down = maze[py + 1][px]
        end
        if px < #maze[1] then
            right = maze[py][px + 1]
        end
        if right == "-" or right == "J" or right == "7" then
            px, py = px + 1, py
            last_move = moves.right
        elseif down == "|" or down == "L" or down == "J" then
            px, py = px, py + 1
            last_move = moves.down
        elseif left == "-" or left == "L" or left == "F" then
            px, py = px - 1, py
            last_move = moves.left
        else
            px, py = px, py - 1
            last_move = moves.up
        end
    elseif current == "L" then
        if last_move == moves.down then
            px, py = px + 1, py
            last_move = moves.right
        else
            px, py = px, py - 1
            last_move = moves.up
        end
    elseif current == "J" then
        if last_move == moves.down then
            px, py = px - 1, py
            last_move = moves.left
        else
            px, py = px, py - 1
            last_move = moves.up
        end
    elseif current == "F" then
        if last_move == moves.left then
            px, py = px, py + 1
            last_move = moves.down
        else
            px, py = px + 1, py
            last_move = moves.right
        end
    elseif current == "7" then
        if last_move == moves.right then
            px, py = px, py + 1
            last_move = moves.down
        else
            px, py = px - 1, py
            last_move = moves.left
        end
    elseif current == "|" then
        if last_move == moves.up then
            px, py = px, py - 1
            last_move = moves.up
        else
            px, py = px, py + 1
            last_move = moves.down
        end
    elseif current == "-" then
        if last_move == moves.right then
            px, py = px + 1, py
            last_move = moves.right
        else
            px, py = px - 1, py
            last_move = moves.left
        end
    end
    steps = steps + 1
end
local function addBorderToGrid(originalGrid)
    local height = #originalGrid
    local width = #originalGrid[1]
    local bordered = {}
    local top_bottom = {}
    for i = 1, width + 2 do
        table.insert(top_bottom, ".")
    end
    table.insert(bordered, top_bottom)
    for i = 1, height do
        local rowWithBorder = { "." }
        for j = 1, width do
            table.insert(rowWithBorder, originalGrid[i][j])
        end
        table.insert(rowWithBorder, ".")
        table.insert(bordered, rowWithBorder)
    end
    table.insert(bordered, top_bottom)

    return bordered
end

local bmap = addBorderToGrid(dmap)

for y, row in ipairs(bmap) do
    for x, val in ipairs(row) do
        local c = tostring(val)
        if #c > 1 then
            io.write(val .. " ")
        else
            io.write(val .. "  ")
        end
    end
    io.write("\n")
end

print(steps / 2)
