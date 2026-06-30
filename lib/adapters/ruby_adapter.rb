# frozen_string_literal: true

require 'lowkey'
require_relative 'adapter'
require_relative '../loader'

module LowLoad
  class RubyAdapter < Adapter
    def extensions = ['rb']

    # Map all definitions and dependencies.
    def map_load(file_path:)
      Lowkey.load(file_path)
    end

    # Then autoload all dependencies for those files.
    def pre_load(file_path:)
      Loader.add_autoloads(file_proxy: Lowkey[file_path])
    end

    # Now we can load the file into Ruby.
    def low_load(file_path:)
      load(file_path)
    end
  end
end
