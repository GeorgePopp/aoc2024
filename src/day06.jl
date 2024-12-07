module day06

const TEST_STRING = """....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."""

mutable struct GuardLocation
    pos::CartesianIndex
    direction::Char
end

function parse1(io::IO)
    num_lines = countlines(io)
    seekstart(io) # countlines brings us to the end of the file, need to return to top to use eachline()

    s_vec = readlines(io)
    num_chars = length(s_vec[1])
    a = Matrix{Bool}(undef, num_lines, num_chars)
    seekstart(io)
    start_pos = CartesianIndex(1,1)
    for (i, line) in enumerate(eachline(io))
        for (j, c) in enumerate(line)
            is_obstacle = c == '#'
            a[i, j] = is_obstacle
            if c == '^'
                start_pos = CartesianIndex(i, j)
            end
        end
    end
    guard = GuardLocation(start_pos, 'u') # Start in up position
    return a, guard
end

function solve1(io::IO)
    a, guard = parse1(io)
    unique_tiles = Set()
    push!(unique_tiles, index_to_tuple(guard.pos))
    while isingrid(guard.pos, a)
        # Take step
        new_pos = nextposition(a, guard)

        # Check to see if it is ok
        if !isingrid(new_pos, a)
            break
        end
        is_barrier = a[new_pos]
        if is_barrier
            # Do not move, turn right
            guard.direction = turnright(guard)
        else
            # Move
            guard.pos = new_pos
            
            # Add position to Set
            push!(unique_tiles, index_to_tuple(guard.pos))
        end
    end
    return length(unique_tiles)
end

@inline function nextposition(a, guard)
    if guard.direction == 'u'
        new_pos = CartesianIndex(guard.pos[1] - 1, guard.pos[2])
    elseif guard.direction == 'd'
        new_pos = CartesianIndex(guard.pos[1] + 1, guard.pos[2])
    elseif guard.direction == 'l'
        new_pos = CartesianIndex(guard.pos[1], guard.pos[2] - 1)
    elseif guard.direction == 'r'
        new_pos = CartesianIndex(guard.pos[1], guard.pos[2] + 1)     
    else
        @error "Unrecognised direction"  
    end
    return new_pos
end

@inline function isingrid(idx::CartesianIndex, a)
    nrow, ncol = size(a)
    return (1<= idx[1] <= ncol) & (1 <= idx[2] <= nrow)
end

function turnright(guard)
    position_vec = ['u','r','d','l']
    current_pos = findfirst(x-> x == guard.direction, position_vec)
    new_pos = current_pos % 4 + 1
    return position_vec[new_pos]
end

function index_to_tuple(idx::CartesianIndex)
    return (idx[1], idx[2])
end

#println(solve1(IOBuffer(TEST_STRING)))
# PART 2

# Could just brute force search
# Could narrow it down by only adding barriers on the known path

function solve2(io::IO)
    a, guard_start = parse1(io)
    guard = deepcopy(guard_start)
    full_path = get_full_path(a, guard)
    res = 0
    a_test = deepcopy(a) # Allocate
    for x in full_path
    #for x in eachindex(a)
        a_test = deepcopy(a)
        guard = deepcopy(guard_start)
        x_pos = CartesianIndex(x)
        a_test[x_pos] = true
        res += does_path_loop(a_test, guard)
    end
    return res
end

function get_full_path(a, guard)
    unique_tiles = Set()
    push!(unique_tiles, index_to_tuple(guard.pos))
    while isingrid(guard.pos, a)
        # Take step
        new_pos = nextposition(a, guard)

        # Check to see if it is ok
        if !isingrid(new_pos, a)
            break
        end
        is_barrier = a[new_pos]
        if is_barrier
            # Do not move, turn right
            guard.direction = turnright(guard)
        else
            # Move
            guard.pos = new_pos
            
            # Add position to Set
            push!(unique_tiles, index_to_tuple(guard.pos))
        end
    end
    return unique_tiles
end

function does_path_loop(a, guard)
    unique_tiles = Set()
    push!(unique_tiles, (guard.pos[1], guard.pos[2], guard.direction))
    while isingrid(guard.pos, a)
        # Take step
        new_pos = nextposition(a, guard)

        # Check to see if it is ok
        if !isingrid(new_pos, a)
            return false
            
        end
        is_barrier = a[new_pos]
        if is_barrier
            # Do not move, turn right
            guard.direction = turnright(guard)
        else
            # Move
            guard.pos = new_pos

        end

        if (guard.pos[1], guard.pos[2], guard.direction) ∈ unique_tiles
            return true
        else
            push!(unique_tiles, (guard.pos[1], guard.pos[2], guard.direction))
        end
    end
end

println(solve2(IOBuffer(TEST_STRING)))

end