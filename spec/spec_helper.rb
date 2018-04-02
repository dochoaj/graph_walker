require_relative '../walkers/base_walker'
require_relative '../walkers/filterable_walker'

RSpec.configure do |config|
  config.color = true
  config.order = 'random'
end