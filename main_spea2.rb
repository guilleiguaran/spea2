require "./spea2"
require "./eval_context"
require "./functions"
require "./restrictions"
require "./solutions"

context = EvalContext.new(Functions, Solutions, Restrictions)
context.load_variables("info.json")
options = {
  :problem_size => 1,
  :search_space => Array.new(problem_size) {|i| [-10, 10] },
  :max_gens => 50,
  :pop_size => 80,
  :archive_size => 40,
  :p_cross => 0.90
}

spea2_instance = Spea2.new(context, options)
#spea2_instance.search
