require 'spec_helper'

describe FilterableWalker do
  before :each do
    graph = {
      :A => { 'A': 0, 'B': 5, 'C': nil, 'D': 5, 'E': 7 },
      :B => { 'A': nil, 'B': 0, 'C': 4, 'D': nil, 'E': nil },
      :C => { 'A': nil, 'B': nil, 'C': 0, 'D': 8, 'E': 2 },
      :D => { 'A': nil, 'B': nil, 'C': 8, 'D': 0, 'E': 6 },
      :E => { 'A': nil, 'B': 3, 'C': nil, 'D': nil, 'E': 0 }
    }

    @walker = FilterableWalker.new(graph)
  end

  it 'should be well instanciated' do
    expect(@walker).to be_an_instance_of FilterableWalker
  end

  it 'should inherit from BaseWalker' do
    expect(described_class).to be < BaseWalker
  end

  describe 'stop_when' do
    it 'should be defined' do
      expect(@walker.respond_to? :stop_when).to be_truthy
    end

    it 'should return an instance of FilterableWalker' do
      response = @walker.stop_when
      expect(response).to be_an_instance_of FilterableWalker
    end
  end

  describe 'accept_when' do
    it 'should be defined' do
      expect(@walker.respond_to? :accept_when).to be_truthy
    end

    it 'should return an instance of FilterableWalker' do
      response = @walker.accept_when
      expect(response).to be_an_instance_of FilterableWalker
    end
  end

  describe 'walk' do
    it 'should be defined' do
      expect(@walker.respond_to? :walk).to be_truthy
    end

    it 'should raise if just stop_criteria is undefined' do
      allow(@walker).to receive(:stop_criteria).and_return(nil)
      allow(@walker).to receive(:accept_criteria).and_return(-> {})
      expect(@walker.accept_criteria.class).to eq(Proc)
      expect{@walker.walk('A', 'A')}.to raise_error RuntimeError
    end

    it 'should raise if just accept_criteria is undefined' do
      allow(@walker).to receive(:stop_criteria).and_return(-> {})
      allow(@walker).to receive(:accept_criteria).and_return(nil)
      expect(@walker.stop_criteria.class).to eq(Proc)
      expect{@walker.walk('A', 'A')}.to raise_error RuntimeError
    end

    it 'should call original implementation' do
      allow(@walker).to receive(:stop_criteria).and_return(-> {})
      allow(@walker).to receive(:accept_criteria).and_return(-> {})
      allow(@walker).to receive(:explore_paths).and_return([])
      expect_any_instance_of(BaseWalker).to receive(:walk)
      @walker.walk('A', 'B')
    end
  end
end
