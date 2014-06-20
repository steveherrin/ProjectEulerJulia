using Base.Test

function calc_fib_terms(max_val)
    terms = [1, 2]
    last_idx = 2
    last_val = terms[end]
    while last_val < max_val
        if last_idx == length(terms)
	    # double the size if we're out of room
	    append!(terms, zeros(Int, length(terms)))
	end
	last_idx += 1
	last_val = terms[last_idx - 1] + terms[last_idx - 2]
	if last_val < max_val
	    terms[last_idx] = last_val
	end
    end
    return terms
end

@test calc_fib_terms(90)[1:10] == [1, 2, 3, 5, 8, 13, 21, 34, 55, 89]

function sum_fib_under(n)
    terms = calc_fib_terms(n)
    return sum(terms)
end

@test sum_fib_under(90) == 231

println("Sum of Fibonacci terms under 4 million is $(sum_fib_under(4e6))")
