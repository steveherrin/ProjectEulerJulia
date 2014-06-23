using Base.Test

function load_data(filename)
    open(filename) do file
        raw_lines = readlines(file)
        N = length(raw_lines)
        data = zeros(Int, (N, N))
        for (i, line) in enumerate(raw_lines)
            line_data = map(parseint, split(strip(line, ' ')))
            append!(line_data, zeros(Int, N-length(line_data)))
            data[:, i] = line_data
        end
    return data
    end
end

type TriIdx
    row::Int
    col::Int
end

function get_left_neighbor_indices(pt::TriIdx)
    neighbors = TriIdx[]
    if pt.row > 1
        push!(neighbors, TriIdx(pt.row - 1, pt.col - 1))
    end
    if pt.row < pt.col
        push!(neighbors, TriIdx(pt.row - 1, pt.row))
    end
    return neighbors
end

# Now go column by column, from left to right
# Add the max of the left neighbors to each pt
# Final column, take the maximum
