module day03
    
const TEST_STRING = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

function solve1(io::IO)
    # Capture with regex
    rx = r"mul\(\d+,\d+\)"
    res = 0
    for s in eachline(io)
        matches = eachmatch(rx, s)
        for m in matches
            res += do_multiplication(m.match)
        end
    end

    return(res)
end

function do_multiplication(s::AbstractString)
    digits = eachmatch(r"\d+", s)
    res = 1
    for d in digits
        res *= parse(Int32, d.match)
    end
    return res
end

# Part 2
# Split string by r"do\(\)|don't\(\)
# Extract on same 

const TEST_STRING2 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

function do_all_mult(s::AbstractString)
    out = 0
    rx = r"mul\(\d+,\d+\)"
    matches = eachmatch(rx, s)
    for m in matches
        out += do_multiplication(m.match)
    end
    return out
end

function solve2(io::IO)
    # Make one large string
    s = ""
    for str in eachline(io)
        s *= str
    end

    # Split string
    rx = r"do\(\)|don't\(\)"
    s_split = split(s, rx)
    

    # Get vector of do / don't commands
    matches = eachmatch(rx, s)
    v = Vector{String}(undef, 1)
    v[1] = "do()" # Assumed to be on at the start
    for m in matches
        push!(v, m.match)
    end
    
    # Loop over substring, skip if "don't()"
    res = 0
    for (command, str) in zip(v, s_split)
        if command == "do()"
            res += do_all_mult(str)
        end
    end
    return res
end



end