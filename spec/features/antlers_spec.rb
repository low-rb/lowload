# frozen_string_literal: true

require 'antlers'
require_relative '../../lib/lowload'

RSpec.describe 'Antlers' do
  context 'with a child node' do
    before do
      LowLoad.lowload('spec/fixtures/antlers/child_node.rbx')
    end

    it 'renders HTML' do
      expect(LowLoad::ChildNode.new.render).to eq("<p>I&#39;m a child</p>")
    end
  end
end
