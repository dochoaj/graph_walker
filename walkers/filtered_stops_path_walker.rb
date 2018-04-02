require_relative 'exhaustive_path_walker'

class FilteredStopsPathWalker < ExhaustivePathWalker
  attr_accessor :stops

  def initialize(graph)
    super(graph)
  end

  def perform(from, to, stops)
    @stops = (stops + 1)
    super(from, to).uniq
  end

  def stop_condition(_from, goal, metadata)
    metadata[:path].count >= @stops && metadata[:path].last == goal
  end

  def postprocess(metadata, _from, _goal)
    return nil unless metadata[:path].count <= @stops
    metadata
  end
end
