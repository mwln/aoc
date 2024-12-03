local reports = {}
local safe_reports = 0

for line in io.lines("input.txt") do
    local report = {}
    for level in line:gmatch("[^ ]+") do
        table.insert(report, tonumber(level))
    end
    table.insert(reports, report)
end

local function create_list_without_index(list, index)
    local new = {}
    for i, v in ipairs(list) do
        if i ~= index then
            table.insert(new, v)
        end
    end
    return new
end

local function is_valid_level(level, next, is_increasing)
    if is_increasing then
        return next > level and next - level <= 3
    else
        return level > next and level - next <= 3
    end
end

local function is_safe_report(report)
    local valid_report = false
    local loop = 0
    while loop < 2 and not valid_report do
        local is_increasing = loop % 2 == 0
        for i = 1, #report - 1 do
            local current = report[i]
            local next = report[i + 1]
            if not is_valid_level(current, next, is_increasing) then
                goto continue
            end
        end
        valid_report = true
        ::continue::
        loop = loop + 1
    end
    return valid_report
end

local function has_safe_subreport(report)
    for i = 1, #report do
        local subreport = create_list_without_index(report, i)
        if is_safe_report(subreport) then
            return true
        end
    end
    return false
end

for _, report in ipairs(reports) do
    if is_safe_report(report) or has_safe_subreport(report) then
        safe_reports = safe_reports + 1
    end
end

print(safe_reports)
