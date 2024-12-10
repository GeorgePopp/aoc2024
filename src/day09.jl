module day09

const TEST_STRING1 = "12345"
const TEST_STRING2 = "2333133121414131402"

const empty_id = Int8(-1)

function parse1(io::IO)
    s = readline(io)
    v = Vector{Int8}(undef, length(s))
    for (i, c) in enumerate(s)
        v[i] = parse(Int8, c)
    end
    return v
end

function expand_disk_map(v::AbstractVector)
    disk_length = sum(v)
    u = Vector{Int64}(undef, disk_length)
    idx = 1
    is_data = true
    count = 0
    for i in 0:(length(v) - 1)
        num = v[i+1]
        if num == 0
            # Do not assign
        elseif is_data
            u[idx:idx+num-1] .= count
            count += 1
        else
            u[idx:idx+num-1] .= empty_id
        end
        idx = idx+num
        is_data = !is_data
    end
    return u
end

function reorder_disk_map!(v::AbstractVector)
    for i = (length(v)):-1:1
        x = v[i]
        if x != -1
            new_loc = findfirst(x -> x == -1, v)
            if new_loc < i
                # Swap
                v[new_loc] = x
                v[i] = -1
            end
        end
    end
    return v
end

function solve1(io::IO)
    v = parse1(io)
    u = expand_disk_map(v)
    reorder_disk_map!(u)
    
    # Calculate checksum
    out = 0
    for i in 1:length(u)
        j = i - 1
        x = u[i]
        if x == -1
            continue
        end
        out += j * x
    end
    return out
end

#println(solve1(IOBuffer(TEST_STRING2))) 1928

# PART 2

function find_block(v::AbstractVector, len_block::Integer)
    u = v .== -1
    bstart = 0
    bend = 0
    prev = false
    for i in 1:length(v)
        if u[i]
            if len_block == 1
                return i
            elseif prev
                bend = i
                if bend - bstart + 1 == len_block
                    return bstart:bend
                end
            else
                bstart = i
            end
            prev = true
        else
            prev = false
        end
    end
    return nothing
end

function reorder_disk_map2!(v::AbstractVector)
    nums = unique(v) |> sort
    nums = [x for x in nums if x != -1]
    for i in reverse(nums)
        block_start = findfirst(x -> x == i, v)
        block_end = findlast(x -> x == i, v)
        block_len = 1 + block_end - block_start
        loc = find_block(v, block_len)


        if !isnothing(loc)
            if block_len == 1
                loc = loc:loc
            end
            if loc[1] < block_start
                # Swap
                v[loc] .= i
                v[block_start:block_end] .= -1
            end
        end
    end
end

function solve2(io::IO)
    v = parse1(io)
    u = expand_disk_map(v)
    reorder_disk_map2!(u)
    
    
    # Calculate checksum
    out = 0
    for i in 1:length(u)
        j = i - 1
        x = u[i]
        if x == -1
            continue
        end
        out += j * x
    end
    return out
end

#println(solve2(IOBuffer(TEST_STRING2)))

end
