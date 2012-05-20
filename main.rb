require "./spea2"
require "./eval_context"

module Functions
  def z
    i + k*m*v+sfcv[0]
  end
end

context = EvalContext.new(Functions)
context.load_variables("info.json")
spea2_instance = Spea2.new(context)
puts spea2_instance.context.z
