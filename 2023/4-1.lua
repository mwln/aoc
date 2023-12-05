local points = 0
for line in io.lines("4.txt") do
    local id = line:match("%d+")
    local pile = line:match(": (.*)")
    local cards = {}
    for item in pile:gmatch("[^|]+") do
        table.insert(cards, item)
    end
    local winners = {}
    for winner in cards[1]:gmatch("[^ ]+") do
        winners[tonumber(winner)] = true
    end
    local matches = -1
    for card in cards[2]:gmatch("[^ ]+") do
        card = tonumber(card)
        if winners[card] then
            matches = matches + 1
        end
    end
    if matches > -1 then
        points = points + (2 ^ matches)
    end
end
print(points)
