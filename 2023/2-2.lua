local total = 0
for line in io.lines("2.txt") do
    local min = { red = -1, green = -1, blue = -1 }
    local game = string.match(line, ":%s(.*)")
    for trick in game:gmatch('([^;]+)') do
        local bag = { red = 0, green = 0, blue = 0 }
        trick = trick:gsub("%s+", "")
        for act in trick:gmatch('([^,]+)') do
            local color = act:match('[%a]+')
            local amount = act:match('[%d]+')
            bag[color] = bag[color] + amount
        end
        for cube, count in pairs(bag) do
            if count > min[cube] then
                min[cube] = count
            end
        end
        bag = { red = 0, green = 0, blue = 0 }
    end
    total = total + (min["red"] * min["green"] * min["blue"])
end
print(total)
