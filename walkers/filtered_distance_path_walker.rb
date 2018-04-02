require_relative 'exhaustive_path_walker'

class FilteredDistancePathWalker < ExhaustivePathWalker
  attr_accessor :distance

  def initialize(graph)
    super(graph)
  end

  def perform(from, to, distance)
    @distance = distance
    super(from, to).uniq
  end

  def stop_condition(_from, goal, metadata)
    metadata[:length] > @distance && metadata[:path].last == goal
  end

  def postprocess(metadata, _from, _goal)
    return nil unless metadata[:length] <= @distance
    metadata
  end
end
