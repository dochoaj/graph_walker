require_relative 'base_walker'

# Smart walker class
class FilterableWalker < BaseWalker
  def stop_when(&block)
    @stop_criteria = block
    self
  end

  def accept_when(&block)
    @accept_criteria = block
    self
  end

  def walk(from, to)
    raise_stop_message unless @stop_criteria
    raise_accept_message unless @accept_criteria
    super(from, to).uniq
  end

  def raise_stop_message
    raise 'Undefined stop criteria, please call stop_when using a block'
  end

  def raise_accept_message
    raise 'Undefined acceptance criteria, please call accept_when using a block'
  end

  def stop_condition(from, to, current)
    @stop_criteria.call(from, to, current)
  end

  def postprocess(from, to, current)
    return nil unless @accept_criteria.call(from, to, current)
    current
  end

end
