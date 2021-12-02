function series(inputs::Array{Float64,2}, problem::Problem, number_of_stages::Int64)

    # initialize -
    solution_array = Array{Solution,1}()
    
    for reactor_index = 1:number_of_stages

        # compute the solution -
        single_reactor_soln = compute_optimal_single_pass_solution(problem)

        # create a new problem for the next stage -
        problem_next_stage = Problem()

        # cache this solution -
        push!(solution_array,single_reactor_soln)
    end

end

function parallel()
end

function compute_optimal_single_pass_solution(problem::Problem)::Solution
end