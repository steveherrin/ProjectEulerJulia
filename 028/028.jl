using Base.Test

function sum_spiral_diagonal_numbers(N::Integer)
    total = 0
    current_number = 1
    skip = 0  # we start from the center, so this will soon get incremented
    corner_number = 3  # 1 is at center
    # keep track of current corner. After we hit 4 on the same spiral
    # we need to start skipping two more to get to the next corner
    # (An NxN square has (N-2) numbers between its outermost corners)
    while current_number <= N^2
        total += current_number
        corner_number = (corner_number + 1) % 4
        if corner_number == 0
            skip += 2
        end
        current_number += skip
    end
    return total
end

@test sum_spiral_diagonal_numbers(1) == 1
@test sum_spiral_diagonal_numbers(3) == 1 + 3 + 5 + 7 + 9
@test sum_spiral_diagonal_numbers(5) == 101

N = 1001
println("The sum of numbers of the diagonals of a $(N)x$(N) spiral ",
        "is $(sum_spiral_diagonal_numbers(N))")
