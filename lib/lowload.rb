# frozen_string_literal: true

require 'lowkey'
require_relative 'loader'

def top_level_binding
  binding
end

module LowLoad
  class << self
    # Files are mapped, autoloaded, then loaded into Ruby in 3 separate stages.
    def dirload(path, pwd = Dir.pwd)
      absolute_path = File.expand_path(path, pwd)
      file_paths = Dir["#{absolute_path}/**/*"]

      # Map all definitions and dependencies first.
      file_paths.each do |file_path|
        Lowkey.load(file_path)
      end

      # Then autoload all dependencies for those files.
      file_paths.each do |file_path| # rubocop:disable Style/CombinableLoops
        Loader.add_autoloads(file_proxy: Lowkey[file_path])
      end

      # Now we can load the files into Ruby.
      file_paths.each do |file_path| # rubocop:disable Style/CombinableLoops
        lowload(file_path)
      end
    end

    # Dependencies must first be loaded by dirload() or required by the file.
    def lowload(file_path)
      case File.extname(file_path).delete_prefix('.')
      when 'rb'
        load(file_path)
      when 'rbx'
        load_rbx(file_proxy: Lowkey[file_path] || Lowkey.load(file_path))
      end
    end

    private

    def load_rbx(file_proxy:)
      file_proxy.definitions.each_value do |class_proxy|
        next unless class_proxy[:render]

        class_proxy[:render].body.wrap(prefix: '%q{', suffix: '}')
      end

      # Not a security risk because "eval" is equivalent to "load" or "require_relative" in this context.
      eval(file_proxy.export, top_level_binding, file_proxy.file_path, 0) # rubocop:disable Security/Eval
    end
  end
end
