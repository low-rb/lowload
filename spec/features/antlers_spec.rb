# frozen_string_literal: true

require 'antlers'
require_relative '../../lib/lowload'

RSpec.describe 'Antlers' do
  let(:event) { 'mock event' }

  context 'with a child node' do
    before do
      LowLoad.lowload('spec/fixtures/rbx/antlers_node.rbx')
    end

    it 'renders HTML' do
      expect(LowLoad::AntlersNode.render(event:).response.read).to eq("<p>I&#39;m a child</p>")
    end
  end
end
