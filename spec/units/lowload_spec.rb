# frozen_string_literal: true

require_relative '../../lib/lowload'

RSpec.describe LowLoad do
  describe '.load' do
    it 'loads a file' do
      LowLoad.load('spec/fixtures/mock_node.rbx')
      expect(MockNode).not_to be(nil)
    end
  end
end
