local digits = { one = 1, two = 2, three = 3, four = 4, five = 5, six = 6, seven = 7, eight = 8, nine = 9 }

local function find_last_number(s)
    local letters = ""
    for i = #s, 1, -1 do
        local char = s:sub(i, i)
        if tonumber(char) then
            return char
        else
            letters = char .. letters
            for key, value in pairs(digits) do
                if letters:find(key) then
                    return value
                end
            end
        end
    end
end

local function find_first_number(s)
    local letters = ""
    for i = 1, #s do
        local char = string.sub(s, i, i)
        if tonumber(char) then
            return char
        else
            letters = letters .. char
            for key, value in pairs(digits) do
                if letters:find(key) then
                    return value
                end
            end
        end
    end
end

local total = 0
for line in io.lines("1-1.txt") do
    local first = find_first_number(line)
    local last = find_last_number(line)
    total = total + tonumber(first .. last)
end
print(total)
