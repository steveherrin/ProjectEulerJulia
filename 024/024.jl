using Base.Test

include("../permute.jl")

function get_nth_permutation(a, n::Integer)
    copy_a = copy(a)
    for i in 1:(n-1)
        permute!(copy_a)
    end
    return copy_a
end

@test get_nth_permutation([0,1,2], 2) == [0, 2, 1]
@test get_nth_permutation([0,1,2], 3) == [1, 0, 2]
@test get_nth_permutation([0,1,2], 7) == [0, 1, 2]
@test get_nth_permutation([0,1,2], 1) == [0, 1, 2]

function vector_to_string(v::Vector)
    return prod(map(string, v))
end

@test vector_to_string([0, 1, 2]) == "012"
@test vector_to_string([1, 0, 0]) == "100"
@test vector_to_string(['a', 'b', 'c']) == "abc"

N = 1000000
digits = collect(0:9)
println("The $(N)th permutation of $(vector_to_string(digits)) is ",
        "$(vector_to_string(get_nth_permutation(digits, N)))")
