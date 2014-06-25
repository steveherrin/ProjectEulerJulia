using Base.Test

day_to_name = [0 => "sunday",
               1 => "monday",
               2 => "tuesday",
               3 => "wednesday",
               4 => "thursday",
               5 => "friday",
               6 => "saturday"]
name_to_day = [day_to_name[day] => day for day in 0:6]

function get_jan_1_weekday(year::Integer)
    # Gauss's algorithm

    day_of_week = (1 +
                   5*((year - 1) % 4) +
                   4*((year - 1) % 100) +
                   6*((year - 1) % 400)) % 7
    return day_of_week
end

@test get_jan_1_weekday(1899) == name_to_day["sunday"]
@test get_jan_1_weekday(1910) == name_to_day["saturday"]
@test get_jan_1_weekday(1988) == name_to_day["friday"]
@test get_jan_1_weekday(2004) == name_to_day["thursday"]

function get_days_in_months(year::Integer)
    days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    if year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
        # leap year
        days_in_month[2] = 29
    end
    return days_in_month
end

# mostly care about leap year logic
@test get_days_in_months(1900) == [31,28,31,30,31,30,31,31,30,31,30,31]
@test get_days_in_months(1904)[2] == 29
@test get_days_in_months(2000)[2] == 29

function get_first_of_month_weekdays(year::Integer)
    month_starting_weekday = zeros(Int, 12)
    month_starting_weekday[1] = get_jan_1_weekday(year)
    days_in_months = get_days_in_months(year)
    last_month_start = month_starting_weekday[1]
    for (last_month, days_in_month) in enumerate(days_in_months[1:end-1])
        next_month_start = (days_in_month + last_month_start) % 7
        month_starting_weekday[last_month + 1] = next_month_start
        last_month_start = next_month_start  # for next iteration
    end
    return month_starting_weekday
end

@test get_first_of_month_weekdays(1900) == [1,4,4,0,2,5,0,3,6,1,4,6]
@test get_first_of_month_weekdays(1904) == [5,1,2,5,0,3,5,1,4,6,2,4]
@test get_first_of_month_weekdays(2014) == [3,6,6,2,4,0,2,5,1,3,6,1]

function get_num_first_sundays(years)
    num = 0
    for year in years
        firsts = get_first_of_month_weekdays(year)
        is_sunday = day -> day == name_to_day["sunday"]
        num_in_year = sum(is_sunday, firsts)
        num += num_in_year
    end
    return num
end

@test get_num_first_sundays([2014]) == 1
@test get_num_first_sundays([2013, 2014]) == 2 + 1

start_yr = 1901
end_yr = 2000
println("In the years $(start_yr) to $(end_yr) (inclusive), ",
        "$(get_num_first_sundays(start_yr:end_yr)) months ",
        "began on Sunday.")
