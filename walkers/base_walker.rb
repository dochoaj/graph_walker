class BaseWalker
  attr_reader :graph

  def initialize(graph)
    @graph = graph
  end

  def perform
    raise 'This must be implemented'
  end

  def postprocess
    raise 'This must be implemented'
  end

  def explore_paths(from, goal, current)
    paths = pick_intermediate_path(current, goal)
    return postprocess(current, from, goal) if yield(from, goal, current)
    available_routes = available_routes(from, reject_nodes(current))
    walked_paths = available_routes.map do |node, length|
      new_meta = update_current(node, length, current)
      explore_paths(node, goal, new_meta) do |xfrom, xgoal, xmeta|
        stop_condition(xfrom, xgoal, xmeta)
      end
    end

    walked_paths.concat(paths).compact.flatten
  end

  def ensure_goal(to, current)
    current[:path].last == to
  end

  def update_current(node, length, current)
    {
      path: current[:path].dup << node,
      length: current[:length] + length
    }
  end

  def pick_intermediate_path(current, to)
    pick_condition = ensure_goal(to, current) && current[:path].count > 1
    pick_condition ? [current] : []
  end

  def reject_nodes(current)
    current[:path]
  end

  def available_routes(node, rejection)
    routes = graph[node].reject do |k, v|
      v.nil? || v.zero? || rejection.include?(k)
    end

    raise 'No route' if routes.empty?

    routes
  end

  def from_to_distance(from, to)
    start = graph[from.to_sym]
    raise 'No city' unless start

    destination = start[to.to_sym]
    raise 'No route' unless destination

    destination
  end
end