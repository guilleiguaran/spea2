require "./spea2"
require "./eval_context"
require "./functions"
require "./restrictions"
require "./solutions"

context = EvalContext.new(Functions, Solutions, Restrictions)
context.load_variables("info.json")
spea2_instance = Spea2.new(context)
puts spea2_instance.context.z1
puts spea2_instance.context.z2
