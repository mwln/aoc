local scratchcards = {}
for line in io.lines("4.txt") do
    local scratcher_id = tonumber(line:match("%d+"))
    if scratcher_id == nil then
        goto continue
    end
    scratchcards[scratcher_id] = (scratchcards[scratcher_id] or 0) + 1
    local game = line:match(": (.*)")
    local cards = {}
    for item in game:gmatch("[^|]+") do
        table.insert(cards, item)
    end
    local winners = {}
    for winner in cards[1]:gmatch("[^ ]+") do
        winners[tonumber(winner)] = true
    end
    local matches = 0
    for card in cards[2]:gmatch("[^ ]+") do
        card = tonumber(card)
        if winners[card] then
            matches = matches + 1
        end
    end
    local copies = scratchcards[scratcher_id]
    if matches > 0 then
        for i = 1, matches do
            local next_id = scratcher_id + i
            if scratchcards[next_id] then
                scratchcards[next_id] = scratchcards[next_id] + copies
            else
                scratchcards[next_id] = copies
            end
        end
    end
    ::continue::
end

local total = 0
for _, amount in pairs(scratchcards) do
    total = total + amount
end
print(total)
