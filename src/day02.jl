module day02

const test_input = """7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9"""

function parseinput(io::IO)
    num_lines = countlines(io)
    seekstart(io) # countlines brings us to the end of the file, need to return to top to use eachline()
    v = Vector{Vector{Integer}}(undef, num_lines)
    for (i,s) in enumerate(eachline(io))
        u_string = split(s)
        u_int = parse.(Int, u_string)
        v[i] = u_int
    end
    return v
end

function solve1(io::IO)
    v = parseinput(io)
    passes = 0
    for u in v
        # Get vector of differences
        u_diff = Vector{Integer}(undef, length(u)-1)
        for i in 1:length(u_diff)
            u_diff[i] = u[i] - u[i+1]
        end

        # Must be between 1 and 3
        u_abs = abs.(u_diff)
        if any(u_abs .> 3) | any(u_abs .< 1)
            continue
        end

        # Check increasing / decreasing
        u_sign = sign.(u_diff)
        if any(u_sign .!= u_sign[1])
            continue
        end

        # Passed all tests
        passes += 1

    end
    return passes
end

#println(solve1(IOBuffer(test_input)))

function check_vector(u::Vector{Integer})
    # Get vector of differences
    u_diff = Vector{Integer}(undef, length(u)-1)
    for i in 1:length(u_diff)
        u_diff[i] = u[i] - u[i+1]
    end

    # Must be between 1 and 3
    u_abs = abs.(u_diff)
    if any(u_abs .> 3) | any(u_abs .< 1)
        return false
    end

    # Check increasing / decreasing
    u_sign = sign.(u_diff)
    if any(u_sign .!= u_sign[1])
        return false
    end

    return true
end

# Helper function to delete ith element from a vector
@views deleteelem(i, a::AbstractVector) = vcat(a[begin:i-1], a[i+1:end])

function solve2(io::IO)
    v = parseinput(io)
    passes = 0
    for u in v
        # Test unmodified vector
        result = check_vector(u)

        if !result
            # Brute force test
            u_drop = Vector{Integer}(undef, length(u) - 1)
            for i in 1:length(u)
                u_drop = deleteelem(i, u)
                result2 = check_vector(u_drop)
                if result2
                    passes += 1
                    break
                end
            end
        else
            passes += 1
        end
    end
    return passes
end

#println(solve2(IOBuffer(test_input)))

end