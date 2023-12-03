local max = { red = 12, green = 13, blue = 14 }
local total = 0
for line in io.lines("2.txt") do
    local bag = { red = 0, green = 0, blue = 0 }
    local id = string.match(line, '%d+')
    local game = string.match(line, ":%s(.*)")
    local possible = true
    for trick in game:gmatch('([^;]+)') do
        trick = trick:gsub("%s+", "")
        for act in trick:gmatch('([^,]+)') do
            local color = act:match('[%a]+')
            local amount = act:match('[%d]+')
            bag[color] = bag[color] + amount
        end
        for cube, count in pairs(bag) do
            if count > max[cube] then
                possible = false
                break
            end
        end
        bag = { red = 0, green = 0, blue = 0 }
    end
    if possible then
        total = total + id
    end
end
print(total)
