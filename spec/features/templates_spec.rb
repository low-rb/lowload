# frozen_string_literal: true

require 'antlers' # LowLoad will not detect antlers unless another gem (such as LowNode) requires it.
require_relative '../../lib/lowload'

RSpec.describe 'Templates' do
  context 'when Ruby with HEREDOC' do
    it 'loads file without error' do
      LowLoad.lowload('spec/fixtures/templates/html_node.rb')
      expect(HTMLNode.template).to be_nil
    end
  end

  context 'when RBX' do
    it 'wraps RBX in a string' do
      LowLoad.lowload('spec/fixtures/templates/rbx_node.rbx')
      expect(RBXNode.template).to be_nil
    end

    context 'with Antlers' do
      it 'creates template' do
        LowLoad.lowload('spec/fixtures/templates/antlers_node.rbx')
        expect(AntlersNode.template).to have_attributes(template: %Q{    <p>{"I'm a child"}</p>\n})
      end
    end

    context 'with HEREDOC' do
      it 'does not wrap RBX in a string' do
        LowLoad.lowload('spec/fixtures/templates/rbx_node.rbx')
        expect(RBXNode.template).to be_nil
      end
    end
  end
end
