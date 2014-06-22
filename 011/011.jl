using Base.Test

function load_grid()
    readdlm("data.txt", ' ', Int, '\n', use_mmap=false)
end

# The overall idea is to take the grid
#   a b
#   c d
# And pad it with N ones, where (N + 1) = (# of adjacent numbers to multiply)
# Why this many? If we create new matrices by shifting
# the matrix over by 0, 1, ..., N - 1 steps we can do the multiplcations
# in parallel. Padding with 1s fills in the holes left by the shifting.
# So we'd get (for N = 1)
#   1 1 1 1
#   1 a b 1
#   1 c d 1
#   1 1 1 1
# And then shifting the matrixes to look at products of 2 adjacent numbers
# we'd do the element-wise multiplications of
#   a b                b 1   c d   d 1   1 c
#   c d  with each of  d 1,  1 1,  1 1,  1 1
# To get a*b, c*d, a*c, b*d, a*d, b*d


# Get row, col coordinates for the corners of a grid with
# original dimensions g_dim, padded by a boundary of size N,
# and shifted by i steps of a shift vector
function get_upper_left_corner(g_dim::(Integer, Integer), N::Integer,
                               i::Integer, shift::(Integer, Integer))
    return (N + 1 + i*shift[1], N + 1 + i*shift[2])
end

function get_bottom_right_corner(g_dim::(Integer, Integer), N::Integer,
                                 i::Integer, shift::(Integer, Integer))
    return (g_dim[1] + N + i*shift[1], g_dim[2] + N + i*shift[2])
end


# Package the corners up in a tuple we can use to slice the matrix
function get_corners(g_dim::(Integer, Integer), N::Integer,
                     i::Integer, shift::(Integer, Integer))
    u_row, l_col = get_upper_left_corner(g_dim, N, i, shift)
    b_row, r_col = get_bottom_right_corner(g_dim, N, i, shift)
    return u_row:b_row, l_col:r_col
end

@test get_corners((2, 2), 0, 0, (0, 0)) == (1:2, 1:2)
@test get_corners((2, 2), 1, 0, (0, 0)) == (2:3, 2:3)
@test get_corners((2, 2), 1, 1, (1, 1)) == (3:4, 3:4)
@test get_corners((2, 2), 1, 1, (0, 1)) == (2:3, 3:4)


function pad_grid(grid::Array, N::Integer)
    # pad the grid with 1s around the boundary so we can
    # do lots of products at once by just shifting the matrix
    g_dim = size(grid)
    new_size = (g_dim[1] + 2*N, g_dim[2] + 2*N)

    padded = ones(Int, new_size)
    padded[get_corners(g_dim, N, 0, (0,0))...] = grid
    return padded
end

@test pad_grid([9 8;7 6], 1) == [1 1 1 1; 1 9 8 1; 1 7 6 1; 1 1 1 1]


function max_product(grid::Array, N_in_a_row::Integer)
    N = N_in_a_row - 1  # it will take 3 shifts to multiply 4 numbers
    g_dim = size(grid)
    padded = pad_grid(grid, N)
    max_prod = 1
    for shift_dir in [(0, 1), (1, 0), (1, 1), (1, -1)]
        result = copy(grid)
        for i in 1:N
            result = result .* padded[get_corners(g_dim, N, i, shift_dir)...]
        end
        max_prod = max(max_prod, maximum(result))
    end
    return max_prod
end

@test max_product([2 3; 4 5], 2) == 20
@test max_product([5 3; 4 5], 2) == 25
@test max_product([5 6; 4 5], 2) == 30
@test max_product([5 6; 6 5], 2) == 36


println("The greatest 4-in-a-row product from the grid given is ",
        "$(max_product(load_grid(), 4))")
