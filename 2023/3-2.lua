local schema = {}
for line in io.lines("3.txt") do
    local row = {}
    for x = 1, #line do
        table.insert(row, line:sub(x, x))
    end
    table.insert(schema, row)
end

local function find_gears(x, y)
    local nearby_gears = {}
    local function is_gear(c)
        return c == "*"
    end
    if y > 1 and is_gear(schema[y - 1][x]) then
        table.insert(nearby_gears, { x, y - 1 })
    end
    if y < #schema and is_gear(schema[y + 1][x]) then
        table.insert(nearby_gears, { x, y + 1 })
    end
    if x < #schema[1] and is_gear(schema[y][x + 1]) then
        table.insert(nearby_gears, { x + 1, y })
    end
    if x > 1 and is_gear(schema[y][x - 1]) then
        table.insert(nearby_gears, { x - 1, y })
    end
    if x > 1 and y > 1 and is_gear(schema[y - 1][x - 1]) then
        table.insert(nearby_gears, { x - 1, y - 1 })
    end
    if x < #schema[1] and y > 1 and is_gear(schema[y - 1][x + 1]) then
        table.insert(nearby_gears, { x + 1, y - 1 })
    end
    if x > 1 and y < #schema and is_gear(schema[y + 1][x - 1]) then
        table.insert(nearby_gears, { x - 1, y + 1 })
    end
    if x < #schema[1] and y < #schema and is_gear(schema[y + 1][x + 1]) then
        table.insert(nearby_gears, { x + 1, y + 1 })
    end
    return nearby_gears
end

local gears = {}
for y, row in ipairs(schema) do
    local number = ""
    local near_gears = {}
    local unique_gears = {}
    local function add_part_number()
        if #near_gears > 0 then
            for coord, _ in pairs(unique_gears) do
                if type(gears[coord]) == "table" then
                    table.insert(gears[coord], tonumber(number))
                else
                    gears[coord] = {}
                    table.insert(gears[coord], tonumber(number))
                end
            end
        end
    end
    for x, item in ipairs(row) do
        if tonumber(item) then
            number = number .. item
            for _, gear in ipairs(find_gears(x, y)) do
                local coord = tostring(gear[1]) .. "," .. tostring(gear[2])
                table.insert(near_gears, coord)
                unique_gears[coord] = 1
            end
            if x == #schema[1] then
                add_part_number()
            end
        else
            add_part_number()
            number = ""
            near_gears = {}
            unique_gears = {}
        end
    end
end

local total_ratio = 0
for coord, ratios in pairs(gears) do
    if #ratios > 1 then
        local ratio = 1
        for _, part_number in ipairs(ratios) do
            ratio = ratio * part_number
        end
        total_ratio = total_ratio + ratio
    end
end
print(total_ratio)
