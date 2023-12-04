local schema = {}
for line in io.lines("3.txt") do
    local row = {}
    for x = 1, #line do
        table.insert(row, line:sub(x, x))
    end
    table.insert(schema, row)
end

local function is_part_number(x, y)
    local function is_symbol(c)
        return c ~= "." and tonumber(c) == nil
    end
    local function top()
        return y > 1 and is_symbol(schema[y - 1][x])
    end
    local function bottom()
        return y < #schema and is_symbol(schema[y + 1][x])
    end
    local function right()
        return x < #schema[1] and is_symbol(schema[y][x + 1])
    end
    local function left()
        return x > 1 and is_symbol(schema[y][x - 1])
    end
    local function top_left()
        return x > 1 and y > 1 and is_symbol(schema[y - 1][x - 1])
    end
    local function top_right()
        return x < #schema[1] and y > 1 and is_symbol(schema[y - 1][x + 1])
    end
    local function bottom_left()
        return x > 1 and y < #schema and is_symbol(schema[y + 1][x - 1])
    end
    local function bottom_right()
        return x < #schema[1] and y < #schema and is_symbol(schema[y + 1][x + 1])
    end
    return bottom() or top() or right() or left() or top_left() or top_right() or bottom_left() or bottom_right()
end

local part_numbers = 0
for y, row in ipairs(schema) do
    local number = ""
    local is_part = false
    for x, item in ipairs(row) do
        if tonumber(item) then
            number = number .. item
            if is_part_number(x, y) then
                is_part = true
            end
            if x == #schema[1] then
                if is_part then
                    part_numbers = part_numbers + tonumber(number)
                end
            end
        else
            if is_part then
                part_numbers = part_numbers + tonumber(number)
            end
            number = ""
            is_part = false
        end
    end
end
print(part_numbers)
