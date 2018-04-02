require_relative 'base_walker'

class DefinedPathWalker < BaseWalker
  def perform(path)
    begin
      path.split('-').each_cons(2).to_a.map do |route|
        from_to_distance(route[0], route[1])
      end.reduce(0, :+)
    rescue
      puts 'NO SUCH ROUTE'
    end
  end
end