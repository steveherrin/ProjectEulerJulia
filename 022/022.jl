using Base.Test

# Requires https://projecteuler.net/project/names.txt

function get_letter_value(letter::Char)
    return int(letter) - int('a') + 1
end

@test get_letter_value('a') == 1
@test get_letter_value('b') == 2
@test get_letter_value('z') == 26


function get_name_value(name::String)
    lower_name = lowercase(name)
    score = sum(map(get_letter_value, collect(lower_name)))
    return score
end

@test get_name_value("abc") == 1+2+3
@test get_name_value("ABC") == 1+2+3
@test get_name_value("COLIN") == 53


function get_name_scores(names::Vector)
    sort!(names)
    scores = [i*get_name_value(name) for (i, name) in enumerate(names)]
    return scores
end

@test get_name_scores(["aab", "aaa", "caa"]) == [3, 8, 15]
@test get_name_scores(["aaa", "aaa", "aaa"]) == [3, 6, 9]


function read_quoted_csv(filename)
    # Right now, readcsv doesn't handle quotes well
    # This is very basic, and won't handle if a comma
    # is inside a string. And it's only for 1D data.
    # But good enough for this problem.
    data = readcsv(filename)[:]
    dequote = str -> replace(str, "\"", "")
    data = map(dequote, data)
    return data
end


function sum_scores_in_file(filename)
    names = read_quoted_csv(filename)
    return sum(get_name_scores(names))
end

filename = "names.txt"
println("The sum of name scores in $(filename) is ",
        "$(sum_scores_in_file(filename))")
