module day05

const TEST_STRING = """47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47"""

function parseinput(io::IO)
    # Create an array to store the rules
    rules = Array{Array{Int32,1}, 1}(undef, 0)
    for s in eachline(io)
        if s == ""
            # Hit the next section
            break
        end
        s_split = split(s, "|")
        v = [parse(Int32, s_split[1]), parse(Int32, s_split[2])]
        push!(rules, v)
    end

    pages = Vector{Vector{Int32}}(undef, 0)
    for s in eachline(io)
        s_split = split(s, ",")
        v = Vector{Int32}(undef, length(s_split))
        for (i, c) in enumerate(s_split)
            v[i] = parse(Int32, c)
        end
        push!(pages, v)
    end

    return rules, pages
end

function solve1(io::IO)
    rules, pages = parseinput(io)
    passes = Vector{Bool}(undef, length(rules))
    total = 0
    for v in pages
        for (i, r) in enumerate(rules)
            passes[i] = check_rule(r,v)
        end
        if all(passes)
            mid_id = length(v) ÷ 2 + 1 
            total += v[mid_id]
        end
    end
    return total
end

function check_rule(rule, v)
    first_num = findfirst(x -> x == rule[1], v)
    second_num = findfirst(x -> x == rule[2], v)
    if isnothing(first_num) | isnothing(second_num)
        return true
    elseif first_num < second_num
        return true
    else
        return false
    end
end

#println(solve1(IOBuffer(TEST_STRING)))

# PART 2

function correct_order!(v, rules, passes)
    while !all(passes)
        rule_id = findfirst(.!passes)
        rule = rules[rule_id]
        correct_with_rule!(v, rule)
        # Find the rules that now pass
        for (i, r) in enumerate(rules)
            passes[i] = check_rule(r,v)
        end
    end   
end

function correct_with_rule!(v, rule)
    first_idx = findfirst(x -> x == rule[1], v)
    first_num = v[first_idx]
    second_idx = findfirst(x -> x == rule[2], v)
    second_num = v[second_idx]

    # Swap
    v[first_idx] = second_num
    v[second_idx] = first_num
    
end

function solve2(io::IO)
    rules, pages = parseinput(io)
    passes = Vector{Bool}(undef, length(rules))
    total = 0
    for v in pages
        for (i, r) in enumerate(rules)
            passes[i] = check_rule(r,v)
        end
        if !all(passes)
            correct_order!(v, rules, passes)
            mid_id = length(v) ÷ 2 + 1 
            total += v[mid_id]
        end
    end
    return total
end


println(solve2(IOBuffer(TEST_STRING)))

end