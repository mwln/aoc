local letter_cards = { T = 10, J = 11, Q = 12, K = 13, A = 14 }

local function strength(hand)
    local strength = 0
    for _, amount in pairs(hand) do
        strength = strength + (amount ^ 2)
    end
    return strength
end

local hands = {}
for line in io.lines("input.txt") do
    local cards, bid = line:match("(.*) (%d+)")
    local hand = {}
    for card in cards:gmatch(".") do
        hand[card] = (hand[card] or 0) + 1
    end
    table.insert(hands, { cards = cards, bid = tonumber(bid), value = strength(hand) })
end

table.sort(hands, function(a, b)
    if a.value == b.value then
        for i = 1, #a.cards do
            local card_a = a.cards:sub(i, i)
            local card_b = b.cards:sub(i, i)
            if card_a ~= card_b then
                local a_value = tonumber(card_a) or letter_cards[card_a]
                local b_value = tonumber(card_b) or letter_cards[card_b]
                return a_value < b_value
            end
        end
    end
    return a.value < b.value
end)

local winnings = 0
for rank, hand in ipairs(hands) do
    winnings = winnings + (hand.bid * rank)
end
print(winnings)
