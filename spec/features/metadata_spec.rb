# frozen_string_literal: true

require_relative '../../lib/lowload'
require_relative '../../lib/metadata'

RSpec.describe 'Metadata' do
  context 'with markdown files' do
    let(:metadata) { LowLoad.dirload('spec/fixtures/metadata') }

    it 'loads metadata' do
      expect(metadata).to have_attributes({
        file_paths: [
          "#{Dir.pwd}/spec/fixtures/metadata/markdown.md",
          "#{Dir.pwd}/spec/fixtures/metadata/raindown.md",
        ],
        tags: {
          'markdown' => "#{Dir.pwd}/spec/fixtures/metadata/markdown.md",
          'raindown' => "#{Dir.pwd}/spec/fixtures/metadata/raindown.md",
        }
      })
    end
  end
end
