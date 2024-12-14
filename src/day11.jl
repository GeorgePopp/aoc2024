module day11

using Memoization

const TEST_STRING = "125 17"



function parse1(io::IO)
    s = readline(io)
    s = split(s)
    s = parse.(Int64, s)
    return s
end

function solve1(io::IO)
    v = parse1(io)
    for i in 1:20
        v = blink(v)
        println(v)
    end
    return length(v)
end

function process_num(x::Int64)
    if x == 0
        return [1]
    elseif iseven(ndigits(x))
        mid_point = ndigits(x) ÷ 2
        dvec = reverse(digits(x))
        num1 = concat_vec_to_int(dvec[1:mid_point])
        num2 = concat_vec_to_int(dvec[mid_point+1:end])
        return [num1, num2]
    else
        return [x * 2024]
    end
end

function concat_vec_to_int(v::Vector{Int})
    s = ""
    for i in 1:length(v)
        s = s * string(v[i])
    end
    return parse(Int64, s)
end

function blink(v)
    v_new = Vector{Int64}(undef, 0)
    for x in v
        stone_vec = process_num(x)
        append!(v_new, stone_vec)
    end
    return v_new
end

#println(solve1(IOBuffer("0")))


# PART 2
# Assume there is some sort of cycle, can try Memoization

function test2(io::IO)
    v = parse1(io)
    a = Vector{Vector{Int}}(undef,0)
    for i in 1:20
        v = blink(v)
        unique_
        push!(a, v)
    end
    println(length(unique(vcat(a...))))
    return length(v)
end

@memoize function blink_num(x::Int64, blinks::Int64)
    if blinks <= 0
        return 1
    end

    v = process_num(x)
    tot = 0
    for y in v
        tot += blink_num(y, blinks-1)
    end
    return tot
end

function solve2(io::IO)
    v = parse1(io)
    res = 0
    for x in v
        res += blink_num(x, 75)
    end
    return res
end

#println(solve2(IOBuffer(TEST_STRING)))
end