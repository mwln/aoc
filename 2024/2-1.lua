local reports = {}
local safe_reports = 0

for line in io.lines("input.txt") do
    local report = {}
    for level in line:gmatch("[^ ]+") do
        table.insert(report, tonumber(level))
    end
    table.insert(reports, report)
end

local function is_increasing_report(report)
    return report[1] < report[2]
end

local function is_safe_report(report)
    if is_increasing_report(report) then
        for i = 1, #report - 1 do
            local current = report[i]
            local next = report[i + 1]
            if current >= next or (next - current) > 3 then return false end
        end
        return true
    else
        for i = 1, #report - 1 do
            local current = report[i]
            local next = report[i + 1]
            if current <= next or (current - next) > 3 then return false end
        end
        return true
    end
end

for _, report in ipairs(reports) do
    if is_safe_report(report) then
        safe_reports = safe_reports + 1
    end
end

print(safe_reports)
