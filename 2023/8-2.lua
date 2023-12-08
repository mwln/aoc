local instructions = {}
local network = {}
local next_nodes = {}
local is_instructions = true
for line in io.lines("input.txt") do
    if #line ~= 0 then
        if is_instructions then
            for rl in line:gmatch("%a") do
                table.insert(instructions, rl)
            end
            is_instructions = false
        else
            local node, left, right = line:match("(%w+) = %((%w+), (%w+)%)")
            if node:sub(-1) == "A" then
                table.insert(next_nodes, node)
            end
            network[node] = { left = left, right = right }
        end
    end
end

local function gcd(a, b)
    while b ~= 0 do
        a, b = b, a % b
    end
    return a
end

local function lcm(a, b)
    return (a * b) / gcd(a, b)
end

local function list_lcm(numbers)
    return #numbers > 1 and lcm(numbers[1], list_lcm({ table.unpack(numbers, 2) })) or (numbers[1] or 1)
end

local instruction_index = 1
local arrivals = {}
local steps = 0
while #arrivals < #next_nodes do
    local instruction = instructions[instruction_index]
    for i, node in ipairs(next_nodes) do
        if node:sub(-1) == "Z" then
            table.insert(arrivals, steps)
        end
        if instruction == "R" then
            next_nodes[i] = network[node].right
        else
            next_nodes[i] = network[node].left
        end
    end
    if instruction_index == #instructions then
        instruction_index = 1
    else
        instruction_index = instruction_index + 1
    end
    steps = steps + 1
end
print(math.floor(list_lcm(arrivals)))
