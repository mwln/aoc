local left = {}
local right = {}
local similarity_score = 0

for line in io.lines("input.txt") do
    local d1, d2 = string.match(line, "^(%d+)%D*(%d+)$")
    table.insert(left, d1)
    right[d2] = (right[d2] or 0) + 1
end

for _, value in pairs(left) do
    similarity_score = similarity_score + ((right[value] or 0) * value)
end

print(similarity_score)
