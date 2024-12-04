local total = 0
local content = io.open("input.txt"):read("*all"):gsub("[\n\r]+", "")

for n1, n2 in string.gmatch(content, "mul%((%d%d?%d?),(%d%d?%d?)%)") do
    total = total + (tonumber(n1) * tonumber(n2))
end

print(total)
