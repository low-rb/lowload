# frozen_string_literal: true

require_relative '../../lib/lowload'

RSpec.describe LowLoad do
  describe '.autoload' do
    it 'loads a directory' do
      LowLoad.autoload('spec/fixtures/directory')

      expect(A).not_to be(nil)
      expect(B).not_to be(nil)
      expect(C).not_to be(nil)
    end
  end

  describe '.load' do
    it 'loads a file' do
      LowLoad.load('spec/fixtures/mock_node.rbx')
      expect(MockNode).not_to be(nil)
    end
  end
end
