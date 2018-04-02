require_relative 'exhaustive_path_walker'

class FilterablePathWalker < ExhaustivePathWalker
  attr_accessor :filter_test

  def initialize(graph)
    super(graph)
  end

  def perform(from, to, &block)
    @filter_test = block
    super(from, to).uniq
  end

  def test_filter(from, to, current)
    @filter_test.call(from, to, current)
  end

  def stop_condition(from, to, current)
    test_filter(from, to, current) && super(from, to, current)
  end

  def postprocess(current, from, to)
    return nil if test_filter(from, to, current)
    current
  end
end
