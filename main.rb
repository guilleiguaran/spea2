require "./spea2"
require "./eval_context"

module Functions
  def z1
    i + k*m*v + sfcv[0]
  end

  def z2
    incrementolineal["interseccion"].inject{|sum, i| sum+i}
  end
end

context = EvalContext.new(Functions)
context.load_variables("info.json")
spea2_instance = Spea2.new(context)
puts spea2_instance.context.z1
puts spea2_instance.context.z2
