require "./spea2"
require "./eval_context"
require "./functions"
require "./restrictions"
require "./solutions"

def print_solution(context, vector, n)
  context.generate_solution(vector)
  csv = CSV.open("solution#{n}.csv", "wb")
  csv << ["g"]
  context.g.each do |gi|
    gi.each do |ex|
      csv << ex
    end
  end
  csv << [""]
  csv << ["q"]
  context.q.each do |qi|
    qi.each do |ex|
      ex.each do |exi|
        csv << exi
      end
    end
  end
  csv << [""]
  csv << ["c"]
  context.c.each do |ci|
    csv << ci
  end
  csv.close
end

context = EvalContext.new(Functions, Solutions, Restrictions)
context.load_variables("info.json")
options = {
  :problem_size => 2,
  :search_space => Array.new(2) {|i| [0, 10] },
  :max_gens => 1,
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
    print_solution(context, x[:vector], n)
  end
  csv.close
end
