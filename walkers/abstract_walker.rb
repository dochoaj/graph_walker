class AbstractWalker
  attr_reader :graph

  def initialize(graph)
    @graph = graph
  end

  def walk(from, to)
    raise 'This must be implemented'
  end

  def postprocess(from, to, current)
    raise 'This must be implemented'
  end
end