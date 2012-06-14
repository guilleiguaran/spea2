require "./spea2"
require "./eval_context"
require "./functions"
require "./restrictions"
require "./solutions"
require "csv"

def print_solution(vectors, context, n)
  csv = CSV.open("solutions/solutions#{n}.csv", "wb")
  vectors.each do |vector|
    context.generate_solution(vector)
  end
  csv.close
end

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
  puts "n: #{n}"
  csv = CSV.open("solutions/pareto#{n}.csv", "wb")
  spea2_instance = Spea2.new(context, options)
  archive = spea2_instance.search
  objectives = archive.map{ |x| x[:objectives] }
  objectives.each{ |o| csv << o }
  vectors = archive.map{ |v| x[:vector] }
  print_solutions(vectors, context, n)
  csv.close
end
