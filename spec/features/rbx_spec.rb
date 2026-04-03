# frozen_string_literal: true

require_relative '../../lib/lowload'

RSpec.describe 'RBX' do
  context 'when the HTML is unescaped' do
    it 'wraps the HTML in a string' do
      LowLoad.lowload('spec/fixtures/html_node.rbx')
      expect(HTMLNode.new.render).to eq("<p>Hello</p>\n")
    end
  end
end
