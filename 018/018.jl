using Base.Test

function load_data(filename)
    open(filename) do file
        raw_lines = readlines(file)
        N = length(raw_lines)
        data = zeros(Int, (N, N))
        for (i, line) in enumerate(raw_lines)
            line_data = map(parseint, split(strip(line, ' ')))
            append!(line_data, zeros(Int, N-length(line_data)))
            data[i, :] = line_data
        end
    return data
    end
end

type TriIdx
    row::Int
    col::Int
end

function ==(a::TriIdx, b::TriIdx)
    return a.row == b.row && a.col == b.col
end

function get_next_row_indices(pt::TriIdx)
    neighbors = TriIdx[]
    push!(neighbors, TriIdx(pt.row + 1, pt.col))
    push!(neighbors, TriIdx(pt.row + 1, pt.col + 1))
end

@test get_next_row_indices(TriIdx(1, 1)) == [TriIdx(2,1); TriIdx(2,2)]
@test get_next_row_indices(TriIdx(2, 2)) == [TriIdx(3,2); TriIdx(3,3)]

function get_greatest_path_sum(filename)
    data = load_data(filename)
    n_row, n_col = size(data)

    # Assume we're on the maximum path, at row N, col M
    # The next step, then, must involve the max of row N+1, col M or M+1
    # And at row 1, we must be at 1,1
    #
    # So this gives us an inductive recipe to find the maximum path's sum
    # That is, add the max of row N+1, col M or M+1 to row N, col M
    # Then repeat for row N-1, etc, up to row 1. The sum then includes
    # every row, and describes a valid path, since we only considered
    # neighbors
    for i_row in (n_row-1):-1:1
        for i_col in 1:(n_col-1)
            if data[i_row, i_col] == 0
                # we're outside of the triangle
                break
            end
            idx = TriIdx(i_row, i_col)
            next_idxs = get_next_row_indices(idx)
            next_vals = Int[]
            for next_idx in next_idxs
                push!(next_vals, data[next_idx.row, next_idx.col])
            end
            data[i_row, i_col] += maximum(next_vals)
        end
    end
    # We've bubbled the maximum sum up to the top
    println("$(data)")
    return data[1, 1]
end

@test get_greatest_path_sum("test_data.txt") == 23
greatest_path_sum = get_greatest_path_sum("data.txt")
println("The greatest sum along a valid path in the given triangle ",
        "is $(greatest_path_sum)")
