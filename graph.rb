require_relative 'walkers/defined_path_walker'
require_relative 'walkers/shortest_path_walker'
require_relative 'walkers/filterable_walker'

graph = {
  :A => { 'A': 0, 'B': 5, 'C': nil, 'D': 5, 'E': 7 },
  :B => { 'A': nil, 'B': 0, 'C': 4, 'D': nil, 'E': nil },
  :C => { 'A': nil, 'B': nil, 'C': 0, 'D': 8, 'E': 2 },
  :D => { 'A': nil, 'B': nil, 'C': 8, 'D': 0, 'E': 6 },
  :E => { 'A': nil, 'B': 3, 'C': nil, 'D': nil, 'E': 0 }
}

walk = DefinedPathWalker.new(graph)
puts walk.perform('A-B-C')
puts walk.perform('A-D')
puts walk.perform('A-D-C')
puts walk.perform('A-E-B-C-D')
puts walk.perform('A-E-D')
puts '-----------------------'
walker = FilterableWalker.new(graph)
puts walker.path_for('C', 'C')
      .stop_when{ |f, t, c| c[:path].count > 4 }
      .accept_when { |f, t, c| c[:path].count.between?(1, 4) && c[:path].last == t }
      .walk
puts '-----------------------'
puts walker.path_for('A', 'C')
      .stop_when{ |f, t, c| c[:path].count > 5 }
      .accept_when { |f, t, c| c[:path].count == 5 && c[:path].last == t }
      .walk
puts '-----------------------'
walk = ShortestPathWalker.new(graph)
puts walk.perform('A', 'C')
puts '-----------------------'
puts walk.perform('B', 'B')
puts '-----------------------'
walker = FilterableWalker.new(graph)
puts walker.path_for('C', 'C')
      .stop_when{ |f, t, c| c[:distance] >= 30 }
      .accept_when { |f, t, c| c[:distance] < 30 && c[:path].last == t }
      .walk
puts '-----------------------'

