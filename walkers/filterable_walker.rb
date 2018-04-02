# Smart walker class
class FilterableWalker
  attr_reader :graph

  def initialize(graph)
    @graph = graph
  end

  def path_for(from, to)
    @from = from
    @to = to
    self
  end

  def stop_when(&block)
    @stop_criteria = block
    self
  end

  def accept_when(&block)
    @accept_criteria = block
    self
  end

  def walk
    raise_stop_message unless @stop_criteria
    raise_accept_message unless @accept_criteria
    raise_goal_message unless @from || @to
    perform(@from, @to).uniq
  end

  def raise_stop_message
    raise 'Undefined stop criteria, please call stop_when using a block'
  end

  def raise_accept_message
    raise 'Undefined acceptance criteria, please call accept_when using a block'
  end

  def raise_goal_message
    raise 'Undefined from or to parameters, please call path_for method'
  end

  def stop_condition(from, to, current)
    @stop_criteria.call(from, to, current)
  end

  def postprocess(from, to, current)
    return nil unless @accept_criteria.call(from, to, current)
    current
  end

  # This should be inherited!
  def perform(from, to)
    from = from.to_sym
    to = to.to_sym
    current = { path: [from], distance: 0 }

    explore_paths(from, to, current) { |f, t, c| stop_condition(f, t, c) }
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
