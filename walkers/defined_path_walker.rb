require_relative 'base_walker'

class DefinedPathWalker < BaseWalker
  def walk(path)
    begin
      path.split('-').each_cons(2).to_a.map do |route|
        walk_mechanism(route[0], route[1])
      end.reduce(0, :+)
    rescue => e
      puts e.message
    end
  end

  def walk_mechanism(from, to)
    start = graph[from.to_sym]
    raise 'No city' unless start

    destination = start[to.to_sym]
    raise 'No route' unless destination

    destination
  end
end