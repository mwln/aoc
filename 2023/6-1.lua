local times = {}
local records = {}
for line in io.lines("input.txt") do
    for n in string.gmatch(line, "%d+") do
        if line:match("Time:") then
            table.insert(times, tonumber(n))
        else
            table.insert(records, tonumber(n))
        end
    end
end

local race_wins = 1
for i, time in ipairs(times) do
    local record = records[i]
    local winners = 0
    for hold = 1, time - 1 do
        if time * hold - (hold ^ 2) > record then
            winners = winners + 1
        end
    end
    race_wins = (winners > 0) and (race_wins * winners) or race_wins
end
print(race_wins)
