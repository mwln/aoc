local total = 0
for line in io.lines("1-1.txt") do
    local numbers = line:gsub("%a", "")
    numbers = string.sub(numbers, 1, 1) .. string.sub(numbers, -1)
    total = tonumber(numbers) + total
end
print(total)
