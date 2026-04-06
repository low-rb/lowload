# frozen_string_literal: true

require_relative '../../lib/lowload'

RSpec.describe LowLoad do
  describe '.dirload' do
    it 'loads a directory' do
      LowLoad.dirload('spec/fixtures/directory')

      expect(Namespace::A).not_to be(nil)
      expect(Namespace::B).not_to be(nil)
      expect(Namespace::C).not_to be(nil)
    end
  end

  describe '.lowload' do
    it 'loads a file' do
      LowLoad.lowload('spec/fixtures/rbx/html_node.rbx')
      expect(HTMLNode).not_to be(nil)
    end
  end
end
