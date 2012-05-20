require "yaml"

class EvalContext
  attr_reader :functions
  def initialize(klass)
    extend klass
    @functions = klass.instance_methods
  end

  def load_variables(filepath)
    config = ::YAML.load_file(filepath)
    config.each do |method_name, return_value|
      self.class.send(:define_method, method_name, -> { return_value })
    end
  end
end
