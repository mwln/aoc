local seeds = {}
local directions = {}

local function map_seeds()
    local new_seeds = {}
    for i, seed in ipairs(seeds) do
        local seed_start = seed[1]
        local seed_end = seed[1] + seed[2] - 1
        for _, map in ipairs(directions) do
            local destination_start = map[1]
            local source_start = map[2]
            local range_length = map[3]
            local source_end = source_start + range_length - 1
            local change = destination_start - source_start
            local overlap_start = math.max(seed_start, source_start)
            local overlap_end = math.min(seed_end, source_end)
            if overlap_start <= overlap_end then
                local overlap_length = overlap_end - overlap_start + 1
                if seed_start < overlap_start and seed_end > overlap_end then
                    seeds[i] = { destination_start, range_length }
                    table.insert(new_seeds, { seed_start, overlap_start - seed_start })
                    table.insert(new_seeds, { overlap_end + 1, seed_end - overlap_end })
                elseif seed_start >= source_start and seed_end <= source_end then
                    seeds[i] = { overlap_start + change, overlap_length }
                elseif seed_start < overlap_start and seed_end <= source_end then
                    seeds[i] = { destination_start, overlap_length }
                    table.insert(new_seeds, { seed_start, overlap_start - seed_start })
                elseif seed_end > overlap_end and seed_start >= source_start then
                    seeds[i] = { overlap_start + change, overlap_length }
                    table.insert(new_seeds, { overlap_end + 1, seed_end - overlap_end })
                end
                goto next_seed
            end
        end
        ::next_seed::
    end
    if #new_seeds > 0 then
        for _, new_seed in ipairs(new_seeds) do
            table.insert(seeds, new_seed)
        end
    end
end

local map_mode = false
for line in io.lines("input.txt") do
    if string.find(line, "seeds:") then
        for seed, range in string.gmatch(line, "(%d+) (%d+)") do
            table.insert(seeds, { tonumber(seed), tonumber(range) })
        end
    elseif string.find(line, "-to-") then
        map_mode = true
    elseif #line == 0 or line == nil then
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
    if seed[1] < lowest then
        lowest = seed[1]
    end
end
print(lowest)
