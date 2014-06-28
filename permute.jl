using Base.Test

function permute!(a)
    # returns the next lexicographic permutation of a

    # find largest k such that a[k] < a[k + 1]
    max_k = 0
    for k in 1:length(a) - 1
        if a[k] < a[k + 1]
            max_k = k
        end
    end
    if max_k == 0
        # end of permutation, so start over
        return reverse!(a)
    end
    # find largest l greater than l such that a[k] < a[l]
    max_l = 0
    for l in 1:length(a)
        if l > max_k && a[max_k] < a[l]
            max_l = l
        end
    end
    (a[max_k], a[max_l]) = (a[max_l], a[max_k])
    reverse!(a, max_k+1)
    return a
end

@test permute!([0, 1, 2]) == [0, 2, 1]
@test permute!([2, 0, 1]) == [2, 1, 0]
@test permute!([2, 1, 0]) == [0, 1, 2]
@test permute!([1, 2, 3, 4]) == [1, 2, 4, 3]
@test permute!([4, 3, 2, 1]) == [1, 2, 3, 4]
