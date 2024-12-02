function import_data(full_path::String)
    input = open(full_path) do file
        readlines(file)
    end

    input_parsed = parse_line.(input)
    input_matrix = mapreduce(permutedims, vcat, input_parsed)

    return input_matrix
end

function parse_line(line::String, sep::String="   ")
    str_vec = split(line, sep)
    int_vec = parse.(Int, str_vec)
    return int_vec
end

function day1_part1(input::AbstractMatrix)

    result = input |> 
        x -> sort(x, dims = 1) |>
        x -> diff(x, dims = 2) |>
        x -> abs.(x) |>
        sum
    return result
end

function appearsin(value::Int, target::AbstractArray)
    return sum(value .== target)
end

function day1_part2(input::AbstractMatrix)
    vals = input[:,1]
    target = Ref(input[:,2])

    result = vals |>
        x -> appearsin.(x, target) |>
        x -> x .* vals |>
        sum

    return result
end

function run_day1(part::String, file_name::String, day::String = "day1")
    full_path = joinpath(pwd(), day, file_name)
    input = import_data(full_path)

    if part == "1"
        result = day1_part1(input)
    elseif part == "2"
        result = day1_part2(input)
    end

    println(result)
end

run_day1(ARGS[1], ARGS[2])