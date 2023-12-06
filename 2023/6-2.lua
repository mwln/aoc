local time = 0
local record = 0
for line in io.lines("input.txt") do
    local s = ""
    for n in string.gmatch(line, "%d+") do
        s = s .. n
    end
    if line:match("Time:") then
        time = tonumber(s) or 0
    else
        record = tonumber(s) or 0
    end
end

local discriminant = time ^ 2 - 4 * record
local x1, x2 = (time + math.sqrt(discriminant)) / 2, (time - math.sqrt(discriminant)) / 2
x1, x2 = math.ceil(math.min(x1, x2)), math.floor(math.max(x1, x2))
print(x2 - x1 + 1)
