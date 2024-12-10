module day10

const TEST_STRING = """89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732"""

function parse1(io::IO)
    num_rows = countlines(io)
    seekstart(io)
    s = readline(io)
    num_cols = length(s)
    seekstart(io)
    a = Matrix{Int8}(undef, num_rows, num_cols)
    for (i, s) in enumerate(eachline(io))
        for j in 1:num_cols
            a[i, j] = parse(Int8, s[j])
        end
    end
    return a
end

function solve1(io::IO)
    a = parse1(io)
    pos_starts = findall(x -> x==0, a)
    peak_array = falses(size(a))
    res = 0
    for pos in pos_starts
        b = deepcopy(peak_array)
        fill_path!(pos, a, b)
        res += sum(b)
    end
    return res
end

function fill_path!(loc::CartesianIndex, a::AbstractArray, b::AbstractArray)
    if !checkbounds(Bool, a, loc[1], loc[2])
        return
    elseif a[loc] ==9
        b[loc] = true
    else
        available_steps = [
            CartesianIndex(loc[1]+1, loc[2]),
            CartesianIndex(loc[1]-1, loc[2]),
            CartesianIndex(loc[1], loc[2]+1),
            CartesianIndex(loc[1], loc[2]-1)
        ]
        cur = a[loc]
        for new_loc in available_steps
            if checkbounds(Bool, a, new_loc[1], new_loc[2])
                if a[new_loc] == cur + 1
                    fill_path!(new_loc, a, b)
                end
            end
        end
    end
end

# PART 2
function solve2(io::IO)
    a = parse1(io)
    pos_starts = findall(x -> x==0, a)
    res = 0
    for pos in pos_starts
        res += num_paths(pos,a)
    end
    return res
end

function num_paths(loc::CartesianIndex, a::AbstractArray)
    if !checkbounds(Bool, a, loc[1], loc[2])
        return
    elseif a[loc] == 9
        return 1
    else
        available_steps = [
            CartesianIndex(loc[1]+1, loc[2]),
            CartesianIndex(loc[1]-1, loc[2]),
            CartesianIndex(loc[1], loc[2]+1),
            CartesianIndex(loc[1], loc[2]-1)
        ]
        cur = a[loc]
        sum_paths = 0
        for new_loc in available_steps
            if checkbounds(Bool, a, new_loc[1], new_loc[2])
                if a[new_loc] == cur + 1
                    sum_paths += num_paths(new_loc, a)
                end
            end
        end
        return sum_paths
    end
end


#println(solve2(IOBuffer(TEST_STRING)))
end