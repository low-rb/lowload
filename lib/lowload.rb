# frozen_string_literal: true

require_relative 'adapters/ruby_adapter'
require_relative 'adapters/rbx_adapter'
require_relative 'loader'

module LowLoad
  class UnsupportedFileType < StandardError; end
  class UnsupportedTemplate < StandardError; end

  class << self
    ADAPTERS = [RubyAdapter.new, RBXAdapter.new]

    # Files are mapped, preloaded, then loaded into Ruby in 3 distinct stages.
    def dirload(path, pwd = Dir.pwd)
      absolute_path = File.expand_path(path, pwd)
      file_paths = Dir["#{absolute_path}/**/*"].filter { !File.directory?(it) }

      step(:map_load, file_paths:)
      step(:pre_load, file_paths:)
      step(:low_load, file_paths:)
    end

    def lowload(file_path)
      adapter = find_adapter(file_path:)

      raise(UnsupportedFileType, "Could not load #{file_path}") if adapter.nil?

      adapter.low_load(file_path:)
    end

    private

    def step(step, file_paths:)
      file_paths.each do |file_path|
        find_adapter(file_path:)&.send(step, file_path:)
      end
    end

    def find_adapter(file_path:)
      extension = File.extname(file_path).delete_prefix('.')
      ADAPTERS.find { |adapter| adapter.extensions.include?(extension) }
    end
  end
end
