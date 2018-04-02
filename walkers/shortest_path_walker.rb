require_relative 'exhaustive_path_walker'

class ShortestPathWalker < ExhaustivePathWalker
  def initialize(graph)
    super(graph)
  end

  def available_routes(node, rejection)
    Hash[*super(node, rejection).min_by { |_k, v| v }]
  end
end