using Base.Test

function get_collatz_seq_length(n::Integer, memo=Dict{Integer,Integer}())
    if haskey(memo, n)
        return memo[n]
    end
    if n == 1
        # stop the recursion
        memo[1] = 1
        return 1
    end
    if n % 2 == 0
        next = div(n, 2)
    else
        next = 3*n + 1
    end
    memo[n] = get_collatz_seq_length(next, memo) + 1
    return memo[n]
end

@test get_collatz_seq_length(1) == 1
@test get_collatz_seq_length(2) == 2
@test get_collatz_seq_length(13) == 10

function get_longest_chain_under(n::Integer)
    memo = Dict{Integer,Integer}()
    sizehint(memo, n)
    max_length = 0
    max_number = 0
    for i in 1:n
        seq_length = get_collatz_seq_length(i, memo)
        if seq_length > max_length
            max_length = seq_length
            max_number = i
        end
    end
    return max_number
end

@test get_longest_chain_under(2) == 2
@test get_longest_chain_under(4) == 3

N = 1000000
println("Longest Collatz sequence starting under $(N) ",
        "starts at $(get_longest_chain_under(N))")
