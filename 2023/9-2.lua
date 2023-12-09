local report = {}
for line in io.lines("input.txt") do
    local history = {}
    for value in line:gmatch("-?%d+") do
        table.insert(history, tonumber(value))
    end
    table.insert(report, history)
end

local function only_zeros(list)
    for _, value in ipairs(list) do
        if value ~= 0 then
            return false
        end
    end
    return true
end

local function list_difference(list)
    local differences = {}
    for i, value in ipairs(list) do
        if i > 1 then
            table.insert(differences, value - list[i - 1])
        end
    end
    return differences
end

local function unshift(numbers)
    if only_zeros(numbers) then
        return 0
    else
        return numbers[1] - unshift(list_difference(numbers))
    end
end

local extrapolated_sum = 0
for _, history in ipairs(report) do
    extrapolated_sum = extrapolated_sum + unshift(history)
end
print(extrapolated_sum)
