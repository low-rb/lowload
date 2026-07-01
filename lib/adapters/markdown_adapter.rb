# frozen_string_literal: true

require 'yaml'
require 'lowkey'
require_relative 'adapter'

module LowLoad
  class MarkdownAdapter < Adapter
    EXTENSIONS = ['md', 'rd', 'markdown', 'raindown']

    def metadata(file_path:)
      meta_lines = []
      yaml_lines = []

      File.foreach(file_path).with_index do |line, index|
        if line.strip == '---'
          meta_lines << index + 1
          break if meta_lines.count > 1
        else
          yaml_lines << line
        end
      end

      YAML.safe_load(yaml_lines.join, symbolize_names: true)
    end
  end
end
