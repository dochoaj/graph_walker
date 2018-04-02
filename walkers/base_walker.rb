class BaseWalker
  attr_reader :graph

  def initialize(graph)
    @graph = graph
  end

  def walk(from, to)
    from = from.to_sym
    to = to.to_sym
    current = { path: [from], distance: 0 }

    explore_paths(from, to, current) { |f, t, c| stop_condition(f, t, c) }
      .uniq
  end

  def postprocess(_from, _to, _current)
    raise 'This must be implemented'
  end

  def pick_intermediate_path(from, to, current)
    pick_condition = ensure_goal(to, current) && current[:path].count > 1
    pick_condition ? [postprocess(from, to, current)] : []
  end

  def explore_paths(from, to, current)
    paths = pick_intermediate_path(from, to, current)
    return postprocess(from, to, current) if yield(from, to, current)
    available_routes = available_routes(from, reject_nodes(current))
    walked_paths = available_routes.map do |node, distance|
      new_current = update_current(node, distance, current)
      explore_paths(node, to, new_current) { |f, t, c| stop_condition(f, t, c) }
    end

    walked_paths.concat(paths).compact.flatten
  end

  def update_current(node, distance, current)
    {
      path: current[:path].dup << node,
      distance: current[:distance] + distance
    }
  end

  def reject_nodes(_current)
    []
  end

  def available_routes(node, rejection)
    routes = graph[node].reject do |k, v|
      v.nil? || v.zero? || rejection.include?(k)
    end

    raise 'No route' if routes.empty?

    routes
  end

  def ensure_goal(to, current)
    current[:path].last == to
  end
end
