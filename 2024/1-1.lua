local left = {}
local right = {}
local total_distance = 0

for line in io.lines("input.txt") do
    local d1, d2 = string.match(line, "^(%d+)%D*(%d+)$")
    table.insert(left, d1)
    table.insert(right, d2)
end

table.sort(left)
table.sort(right)

for i = 1, #left do
    local d1, d2 = left[i], right[i]
    total_distance = total_distance + math.abs(d1 - d2)
end

print(total_distance)
