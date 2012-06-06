class Spea2
  BITS_PER_PARAM = 16

  attr_accessor :context

  def initialize(context)
    self.context = context
  end

  def decode(bitstring, search_space)
    vector = []
    search_space.each_with_index do |bounds, i|
      off, sum, j = i*BITS_PER_PARAM, 0.0, 0
      bitstring[off...(off+BITS_PER_PARAM)].reverse.each_char do |c|
        sum += ((c=='1') ? 1.0 : 0.0) * (2.0 ** j.to_f)
        j += 1
      end
      min, max = bounds
      vector << min + ((max-min)/((2.0**BITS_PER_PARAM.to_f)-1.0)) * sum
    end
    return vector
  end

  def point_mutation(bitstring)
    child = ""
    bitstring.size.times do |i|
      bit = bitstring[i]
      child << ((rand() < 1.0/bitstring.length.to_f) ? ((bit=='1') ? "0" : "1") : bit)
    end
    return child
  end

  def uniform_crossover(parent1, parent2, p_crossover)
    return "" + parent1[:bitstring] if rand() >= p_crossover
    child = ""
    parent1[:bitstring].size.times do |i|
      child << ((rand() < 0.5) ? parent1[:bitstring][i] : parent2[:bitstring][i])
    end
    return child
  end

  def reproduce(selected, population_size, p_crossover)
    children = []
    selected.each_with_index do |p1, i|
      p2 = (i.even?) ? selected[i+1] : selected[i-1]
      child = {}
      child[:bitstring] = uniform_crossover(p1, p2, p_crossover)
      child[:bitstring] = point_mutation(child[:bitstring])
      children << child
    end
    return children
  end

  def random_bitstring(num_bits)
    return (0...num_bits).inject(""){|s,i| s << ((rand<0.5) ? "1" : "0")}
  end

  def calculate_objectives(pop, search_space)
    pop.each do |p|
      p[:vector] = decode(p[:bitstring], search_space)
      p[:objectives] = []
      context.generate_solutions(p[:vector])
      context.objectives.each do |objective|
        p[:objectives] << context.public_send(objective)
      end
    end
  end

  def dominates(p1, p2)
    p1[:objectives].each_with_index do |x, i|
      return false if x > p2[:objectives][i]
    end
    return true
  end

  def weighted_sum(x)
    return x[:objectives].inject(0.0) {|sum, x| sum + x}
  end

  def distance(c1, c2)
    sum = 0.0
    c1.each_with_index { |x,i| sum += (c1[i]-c2[i])**2.0 }
    return Math.sqrt(sum)
  end

  def calculate_dominated(pop)
    pop.each do |p1|
      p1[:dom_set] = pop.select { |p2| dominates(p1, p2) }
    end
  end

  def calculate_raw_fitness(p1, pop)
    return pop.inject(0.0) do |sum, p2|
      (dominates(p2, p1)) ? sum + p2[:dom_set].size.to_f : sum
    end
  end

  def calculate_density(p1, pop)
    pop.each {|p2| p2[:dist] = distance(p1[:objectives], p2[:objectives])}
    list = pop.sort{ |x,y| x[:dist] <=> y[:dist] }
    k = Math.sqrt(pop.length).to_i
    return 1.0 / (list[k][:dist] + 2.0)
  end

  def calculate_fitness(pop, archive, search_space)
    calculate_objectives(pop, search_space)
    union = archive + pop
    calculate_dominated(union)
    union.each do |p1|
      p1[:raw_fitness] = calculate_raw_fitness(p1, union)
      p1[:density] = calculate_density(p1, union)
      p1[:fitness] = p1[:raw_fitness] + p1[:density]
    end
  end

  def environmental_selection(pop, archive, archive_size)
    union = archive + pop
    environment = union.select {|p| p[:fitness]<1.0}
    if environment.length < archive_size
      union.sort!{|x,y| x[:fitness] <=> y[:fitness]}
      union.each do |p|
        environment << p if p[:fitness] >= 1.0
        break if environment.length >= archive_size
      end
    elsif environment.length > archive_size
      begin
        k = Math.sqrt(environment.length).to_i
        environment.each do |p1|
          environment.each {|p2| p2[:dist] = distance(p1[:objectives], p2[:objectives])}
          list = environment.sort{|x,y| x[:dist]<=>y[:dist]}
          p1[:density] = list[k][:dist]
        end
        environment.sort!{|x,y| x[:density]<=>y[:density]}
        environment.shift
      end until environment.length >= archive_size
    end
    return environment
  end

  def binary_tournament(pop)
    s1, s2 = pop[rand(pop.size)], pop[rand(pop.size)]
    return (s1[:fitness] < s2[:fitness]) ? s1 : s2
  end

  def search(problem_size, search_space, max_gens, pop_size, archive_size, p_crossover)
    pop = Array.new(pop_size) do |i|
      {:bitstring => random_bitstring(problem_size*BITS_PER_PARAM)}
    end
    gen, archive = 0, []
    begin
      calculate_fitness(pop, archive, search_space)
      archive = environmental_selection(pop, archive, archive_size)
      best = archive.sort{ |x,y| weighted_sum(x)<=>weighted_sum(y) }.first
      puts ">gen=#{gen}, best: x=#{best[:vector]}, objs=#{best[:objectives].join(', ')}"
      if gen >= max_gens
        archive = archive.select { |p| p[:fitness] < 1.0 }
        break
      else
        selected = Array.new(pop_size){ binary_tournament(archive) }
        pop = reproduce(selected, pop_size, p_crossover)
        gen += 1
      end
    end while true
    return archive
  end
end
