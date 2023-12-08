local instructions = {}
local network = {}
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
            network[node] = { left = left, right = right }
        end
    end
end

local next_node = "AAA"
local instruction_index = 1
local steps = 0
while next_node ~= "ZZZ" do
    local instruction = instructions[instruction_index]
    if instruction == "R" then
        next_node = network[next_node].right
    else
        next_node = network[next_node].left
    end
    if instruction_index == #instructions then
        instruction_index = 1
    else
        instruction_index = instruction_index + 1
    end
    steps = steps + 1
end
print(steps)
