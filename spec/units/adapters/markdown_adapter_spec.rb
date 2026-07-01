# frozen_string_literal: true

require_relative '../../../lib/adapters/markdown_adapter'

RSpec.describe LowLoad::MarkdownAdapter do
  subject(:adapter) { described_class.new }

  describe '#metadata' do
    let(:file_path) { File.expand_path('../../fixtures/metadata/markdown.md', __dir__) }

    it 'loads yaml data' do
      expect(adapter.metadata(file_path:)).to eq({
        title: 'Title',
        tags: ['markdown'],
      })
    end
  end
end
