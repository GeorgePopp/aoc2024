module day08

const TEST_STRING = """............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............"""

function parseinput(io::IO)
    num_rows = countlines(io)
    seekstart(io)
    s = readline(io)
    num_cols = length(s)
    seekstart(io)
    a = Matrix{Char}(undef, num_rows, num_cols)
    for (i, s) in enumerate(eachline(io))
        for j in 1:num_cols
            a[i, j] = s[j]
        end
    end
    return a
end

function solve1(io::IO)
    a = parseinput(io)
    antenna_chars = [x for x in unique(vec(a)) if x != '.']
    nrow, ncol = size(a)
    antinode_array = falses(nrow, ncol)
    for c in antenna_chars
        locs = findall(x -> x == c, a)
        for i in 1:length(locs) # Could use IterTools.jl to make it easier to read
            for j in (i+1):length(locs)
                loc1 = locs[i]
                loc2 = locs[j]
                antinode_locs = reflect(loc1, loc2)
                valid_anitnode_locs = antinode_locs[isingrid.(antinode_locs, nrow, ncol)]
                antinode_array[valid_anitnode_locs] .= true
            end
        end
    end
    return sum(antinode_array)
end

function reflect(loc1::CartesianIndex, loc2::CartesianIndex)
    row_diff = loc2[1] - loc1[1]
    col_diff = loc2[2] - loc1[2]
    new1 = CartesianIndex(
        loc1[1] - row_diff,
        loc1[2] - col_diff
    )
    new2 = CartesianIndex(
        loc2[1] + row_diff,
        loc2[2] + col_diff
    )
    return [new1, new2]
end

@inline function isingrid(idx::CartesianIndex, nrow::Integer, ncol::Integer)
    return (1<= idx[1] <= ncol) & (1 <= idx[2] <= nrow)
    # Alternatively
    #checkbounds(Bool, a, idx[1], idx[2])
end

#println(solve1(IOBuffer(TEST_STRING))) #14


# Part 2
function reflect_and_repeat(loc1::CartesianIndex, loc2::CartesianIndex, nrow::Integer, ncol::Integer)
    out_vec = []
    row_diff = loc2[1] - loc1[1]
    col_diff = loc2[2] - loc1[2]
    new1 = loc1
    while isingrid(new1, nrow, ncol)
        push!(out_vec, new1)
        new1 = CartesianIndex(new1[1] - row_diff, new1[2] - col_diff)
    end

    new2 = loc2
    while isingrid(new2, nrow, ncol)
        push!(out_vec, new2)
        new2 = CartesianIndex(new2[1] + row_diff, new2[2] + col_diff)
    end
    return out_vec
end

function solve2(io::IO)
    a = parseinput(io)
    antenna_chars = [x for x in unique(vec(a)) if x != '.']
    nrow, ncol = size(a)
    antinode_array = falses(nrow, ncol)
    for c in antenna_chars
        locs = findall(x -> x == c, a)
        for i in 1:length(locs) # Could use IterTools.jl to make it easier to read
            for j in (i+1):length(locs)
                loc1 = locs[i]
                loc2 = locs[j]
                valid_antinode_locs = reflect_and_repeat(loc1, loc2, nrow, ncol)
                for loc in valid_antinode_locs
                    antinode_array[loc] = true
                end
            end
        end
    end
    return sum(antinode_array)
end

println(solve2(IOBuffer(TEST_STRING))) #34

end