local total = 0
local content = io.open("input.txt")
    :read("*all")
    :gsub("[\n\r]+", "")
    :gsub([[don't%(%)]], "DISABLE")
    :gsub([[do%(%)]], "ENABLE") .. ("DISABLE")

local function sum_mul_instructions(str)
    local sum = 0
    for n1, n2 in str:gmatch("mul%((%d%d?%d?),(%d%d?%d?)%)") do
        sum = sum + (tonumber(n1) * tonumber(n2))
    end
    return sum
end

local loop = 0
for _, disabled in content:gmatch("((.-)DISABLE*)") do
    if loop == 0 then
        total = total + sum_mul_instructions(disabled)
    end
    for _, enabled in disabled:gmatch("(ENABLE(.+))") do
        total = total + sum_mul_instructions(enabled)
    end
    loop = loop + 1
end

print(total)
