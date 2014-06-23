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
