local seeds = {}
local directions = {}

local function map_seeds()
    for i, seed in ipairs(seeds) do
        for _, map in ipairs(directions) do
            local destination_start = map[1]
            local source_start = map[2]
            local range_length = map[3]
            local change = destination_start - source_start
            if seed < source_start + range_length and seed >= source_start then
                seeds[i] = seed + change
                goto next_seed
            end
        end
        ::next_seed::
    end
end

local map_mode = false
for line in io.lines("input.txt") do
    if string.find(line, "seeds:") then
        for seed in string.gmatch(line, "%d+") do
            table.insert(seeds, tonumber(seed))
        end
    elseif string.find(line, "-to-") then
        map_mode = true
    elseif #line == 0 then
        map_mode = false
        if #directions > 0 then
            map_seeds()
        end
        directions = {}
    elseif map_mode then
        local numbers = {}
        for num in string.gmatch(line, "%d+") do
            table.insert(numbers, tonumber(num))
        end
        table.insert(directions, numbers)
    end
end

map_seeds()
local lowest = math.huge
for _, seed in ipairs(seeds) do
    if seed < lowest then
        lowest = seed
    end
end
print(lowest)
