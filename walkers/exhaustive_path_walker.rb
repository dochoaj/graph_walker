require_relative 'base_walker'

class ExhaustivePathWalker < BaseWalker
  def perform(from, to)
    explore_paths(
      from.to_sym, to.to_sym, path: [from.to_sym], length: 0
    ) do |xfrom, xto, xcurrent|
      stop_condition(xfrom, xto, xcurrent)
    end
  end

  def stop_condition(_from, to, current)
    ensure_goal(to, current) && current[:path].count > 1
  end

  def reject_nodes(_current)
    []
  end

  def postprocess(current, _from, _goal)
    current
  end
end
