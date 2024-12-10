module day07
    
const TEST_STRING = """190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20"""


function parse1(io::IO)
    num_lines = countlines(io)
    seekstart(io) # countlines brings us to the end of the file, need to return to top to use eachline()
    result_vec = Vector{Int64}(undef, num_lines)
    numbers_vec = Vector{Vector{Int64}}(undef, num_lines)
    for (i,s) in enumerate(eachline(io))
        s_split = split(s, ':')
        result_vec[i] = parse(Int64, s_split[1])
        num_vec = split(strip(s_split[2]))
        num_vec = parse.(Int64, num_vec)
        numbers_vec[i] = num_vec
    end
    return result_vec, numbers_vec
end

function solve1(io::IO)
    result_vec, numbers_vec = parse1(io)
    operations = [*, +]
    out = 0
    for (i, vec) in enumerate(numbers_vec)
        target_result = result_vec[i]
        possible_combns = (length(vec) - 1)    
        combinations = collect(Iterators.product(fill(operations, possible_combns)...))
        for combination in combinations
            running_total = vec[1]
            for j in 1:(length(vec) - 1)
                op = combination[j]
                running_total = op(running_total, vec[j+1])
            end
            
            if running_total == target_result
                out += target_result
                break
            end
        end
    end
    return out
end

# Part 2
function concatdigits(a::Integer, b::Integer)
    return trunc(Int64, a * 10^ndigits(b) + b)
end


function solve2(io::IO)
    result_vec, numbers_vec = parse1(io)
    operations = [*, +, concatdigits]
    out = 0
    for (i, vec) in enumerate(numbers_vec)
        target_result = result_vec[i]
        possible_combns = (length(vec) - 1)    
        combinations = collect(Iterators.product(fill(operations, possible_combns)...))
        for combination in combinations
            running_total = vec[1]
            for j in 1:(length(vec) - 1)
                op = combination[j]
                running_total = op(running_total, vec[j+1])
            end
            
            if running_total == target_result
                out += target_result
                break
            end
        end
    end
    return out
end

println(solve2(IOBuffer(TEST_STRING)))

end