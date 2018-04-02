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

walker = DefinedPathWalker.new(graph)
puts walker.walk('A-B-C')
puts walker.walk('A-D')
puts walker.walk('A-D-C')
puts walker.walk('A-E-B-C-D')
puts walker.walk('A-E-D')
puts '-----------------------'
walker = FilterableWalker.new(graph)
puts walker
      .stop_when{ |f, t, c| c[:path].count > 4 }
      .accept_when { |f, t, c| c[:path].count.between?(1, 4) && c[:path].last == t }
      .walk('C', 'C')
puts '-----------------------'
puts walker
      .stop_when{ |f, t, c| c[:path].count > 5 }
      .accept_when { |f, t, c| c[:path].count == 5 && c[:path].last == t }
      .walk('A', 'C')
puts '-----------------------'
walker = ShortestPathWalker.new(graph)
puts walker.walk('A', 'C')
puts '-----------------------'
puts walker.walk('B', 'B')
puts '-----------------------'
walker = FilterableWalker.new(graph)
puts walker
      .stop_when{ |f, t, c| c[:distance] >= 30 }
      .accept_when { |f, t, c| c[:distance] < 30 && c[:path].last == t }
      .walk('C', 'C')
puts '-----------------------'

