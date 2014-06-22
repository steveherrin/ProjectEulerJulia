using Base.Test

# To cross from upper left to bottom right of an NxN grid,
# being able to move only down and right, you need a total
# of 2N moves (N right + N down)
# The number of possible paths is the number of ways to
# order those moves.
# If you place all N "downs" in the 2N slots, that completely
# determines where the "rights" are.
# So there are 2N choose N possible paths.

N = 20
println("In a $(N)x$(N) grid, there are $(binomial(2*N, N)) ",
        "paths from upper-left to bottom-right moving only ",
        "right and down.")
