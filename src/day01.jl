module day01

using ..InlineTest

const test_string = """3   4
4   3
2   5
1   3
3   9
3   3"""

function solve1(io::IO)
    # Get vectors from IO
    v1, v2 = parse1(io)

    # Sort
    sort!(v1)
    sort!(v2)

    # Find the distance
    a = abs.(v1 .- v2)
    return(sum(a))
end

function parse1(io::IO)
    num_lines = countlines(io)
    seekstart(io) # countlines brings us to the end of the file, need to return to top to use eachline()

    v1 = Vector{Integer}(undef, num_lines)
    v2 = Vector{Integer}(undef, num_lines)

    for (i,s) in enumerate(eachline(io))
        svec = split(s)
        v1[i] = parse(Int32, svec[1])
        v2[i] = parse(Int32, svec[2])
    end
    return v1, v2
end

#print(solve1(IOBuffer(test_string)))


# PART 2

function solve2(io::IO)
    # Get vectors from IO
    v1, v2 = parse1(io)

    score = 0
    for x in v1
        count = sum(v2 .== x)
        score += x * count
    end
    return score
end

# TESTS
@testset "day01" begin
    @test solve1(IOBuffer(test_string)) == 11
    @test solve2(IOBuffer(test_string)) == 31
end


end