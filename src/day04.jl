module day04

const TEST_STRING1 = """..X...
.SAMX.
.A..A.
XMAS.S
.X...."""

const TEST_STRING2 = """MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"""

const TEST_STRING3 = """....XXMAS.
.SAMXMS...
...S..A...
..A.A.MS.X
XMASAMX.MM
X.....XA.A
S.S.S.S.SS
.A.A.A.A.A
..M.M.M.MM
.X.X.XMASX"""

function parse1(io::IO)
    s_vec = readlines(io)
    num_chars = length(s_vec[1])
    num_lines = length(s_vec)
    a = Array{Char}(undef, num_lines, num_chars)
    for i in 1:num_lines
        for j in 1:num_chars
            a[i,j] = s_vec[i][j]
        end
    end
    #println(a)
    return a
end

function solve1(io::IO)
    a = parse1(io)

    # Loop over each element of a, if it is an X search all directions 
    # Looping goes down first
    nrow, ncol = size(a)
    counts = 0
    for i in 1:nrow
        for j in 1:ncol
            idx = CartesianIndex(i, j)
            c = a[idx]

            if c == 'X'
                counts += search_all_directions(idx, a)
                
            end
        end
        
    end
    return counts
    
end

function search_all_directions(pos, a)
    i = pos[1]
    j = pos[2]
    ncol, nrow = size(a)
    correct_vec = ['M','A','S']

    # Up
    test_idx_up = [
        CartesianIndex(i, j+1),
        CartesianIndex(i, j+2),
        CartesianIndex(i, j+3)
    ]

    # Down
    test_idx_down = [
        CartesianIndex(i, j-1),
        CartesianIndex(i, j-2),
        CartesianIndex(i, j-3)
    ]

    # Left
    test_idx_left = [
        CartesianIndex(i-1, j),
        CartesianIndex(i-2, j),
        CartesianIndex(i-3, j)
    ]

    # Right
    test_idx_right = [
        CartesianIndex(i+1, j),
        CartesianIndex(i+2, j),
        CartesianIndex(i+3, j)
    ]

    # Left + Up
    test_idx_left_up = [
        CartesianIndex(i-1, j+1),
        CartesianIndex(i-2, j+2),
        CartesianIndex(i-3, j+3)
    ]

    # Right + Up
    test_idx_right_up = [
        CartesianIndex(i+1, j+1),
        CartesianIndex(i+2, j+2),
        CartesianIndex(i+3, j+3)
    ]

    # Left + Down
    test_idx_left_down = [
        CartesianIndex(i-1, j-1),
        CartesianIndex(i-2, j-2),
        CartesianIndex(i-3, j-3)
    ]

    # Right + Down
    test_idx_right_down = [
        CartesianIndex(i+1, j-1),
        CartesianIndex(i+2, j-2),
        CartesianIndex(i+3, j-3)
    ]

    test_vec = [
        test_idx_down,
        test_idx_up,
        test_idx_left,
        test_idx_right,
        test_idx_left_down,
        test_idx_left_up,
        test_idx_right_down,
        test_idx_right_up
    ]
    res = 0
    #println(test_vec)

    for test in test_vec
        # Check that the coordinates fit in a
        valid_coords = all(map(x -> valid_index(x, ncol, nrow), test))
        if !valid_coords
            #println("Invalid:")
            #println(test)
            continue
        end

        # Check that they spell XMAS
        char_vec = a[test]
        #print(char_vec)
        pass = (char_vec == correct_vec)
        res += pass
    end
    #println(pos)
    #println(res)
    return res
end


function valid_index(idx, ncol, nrow)
    if (1 <= idx[1] <= ncol) & (1 <= idx[2] <= nrow)
        return true
    else
        return false
    end
end


#println(solve1(IOBuffer(TEST_STRING3)))

# PART 2

const TEST_STRING4 = """.M.S......
..A..MSMS.
.M.S.MAA..
..A.ASMSM.
.M.S.M....
..........
S.S.S.S.S.
.A.A.A.A..
M.M.M.M.M.
.........."""

function solve2(io::IO)
    a = parse1(io)
    # Loop over each element of a, if it is an A search all diagonal adj 
    # Looping goes down first
    nrow, ncol = size(a)
    counts = 0
    for i in 1:nrow
        for j in 1:ncol
            idx = CartesianIndex(i, j)
            c = a[idx]

            if c == 'A'
                counts += search_xmas_grid(idx, a)
                
            end
        end
        
    end
    return counts 
end

function search_xmas_grid(pos, a)
    i = pos[1]
    j = pos[2]
    ncol, nrow = size(a)
    correct_results = [
        ['S','M','S','M'],
        ['S','S','M','M'],
        ['M','M','S','S'],
        ['M','S','M','S']
    ]
    
    # Define grid
    grid = [
        CartesianIndex(i+1, j+1),
        CartesianIndex(i+1, j-1),
        CartesianIndex(i-1, j+1),
        CartesianIndex(i-1, j-1)
    ]
    valid_coords = all(map(x -> valid_index(x, ncol, nrow), grid))
    if valid_coords
        test_result = a[grid]
        if test_result ∈ correct_results
            return 1
        end
        
    end
    return 0
end

#println(solve2(IOBuffer(TEST_STRING4)))

end