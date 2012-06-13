require "./spea2"
require "./eval_context"
require "./functions"
require "./restrictions"
require "./solutions"

context = EvalContext.new(Functions, Solutions, Restrictions)
context.load_variables("info.json")
options = {
  :problem_size => 2,
  :search_space => Array.new(2) {|i| [0, 10] },
  :max_gens => 50,
  :pop_size => 80,
  :archive_size => 40,
  :p_cross => 0.98
}

(10..14).each do |n|
  context.n = n
  csv = CSV.open("pareto#{n}.csv", "wb")
  spea2_instance = Spea2.new(context, options)
  archive = spea2_instance.search
  archive.each do |x|
    csv << x[:objectives].join(",").split(",")
  end
  csv.close
end
