# frozen_string_literal: true

require_relative 'adapters/markdown_adapter'
require_relative 'adapters/rbx_adapter'
require_relative 'adapters/ruby_adapter'
require_relative 'loader'
require_relative 'metadata'

module LowLoad
  class UnsupportedFileType < StandardError; end
  class UnsupportedTemplate < StandardError; end

  class << self
    ADAPTERS = [MarkdownAdapter.new, RBXAdapter.new, RubyAdapter.new]

    def dirload(path, pwd = Dir.pwd)
      absolute_path = File.expand_path(path, pwd)
      file_paths = Dir["#{absolute_path}/**/*"].filter { !File.directory?(it) }

      file_path_adapters = file_paths.each_with_object({}) do |file_path, hash|
        hash[file_path] = find_adapter(file_path:)
      end

      metadata = Metadata.new
      metadata.process(file_path_adapters:)
      step(:preload, file_path_adapters:)
      step(:evaluate, file_path_adapters:)

      metadata
    end

    def lowload(file_path)
      adapter = find_adapter(file_path:)

      raise(UnsupportedFileType, "Could not load #{file_path}") if adapter.nil?

      adapter.evaluate(file_path:)
    end

    def step(step, file_path_adapters:)
      file_path_adapters.each do |file_path, adapter|
        adapter&.send(step, file_path:)
      end
    end

    def find_adapter(file_path:)
      extension = File.extname(file_path).delete_prefix('.')
      ADAPTERS.find { |adapter| adapter.class::EXTENSIONS.include?(extension) }
    end
  end
end
