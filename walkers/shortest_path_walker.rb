require_relative 'base_walker'

class ShortestPathWalker < BaseWalker
  def initialize(graph)
    super(graph)
  end

  def available_routes(node, rejection)
    Hash[*super(node, rejection).min_by { |_k, v| v }]
  end

  def stop_condition(_from, to, current)
    ensure_goal(to, current) && current[:path].count > 1
  end

  def postprocess(from, to, current)
    current
  end
end