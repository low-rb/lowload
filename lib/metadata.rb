# frozen_string_literal: true

require_relative 'adapters/markdown_adapter'

module LowLoad
  class Metadata
    EXTENSIONS = [
      *::LowLoad::MarkdownAdapter::EXTENSIONS,
      *::LowLoad::RBXAdapter::EXTENSIONS,
      *::LowLoad::RubyAdapter::EXTENSIONS,
    ]

    attr_accessor :file_paths, :file_types, :tags

    def initialize
      @file_paths = []

      @file_types = EXTENSIONS.each_with_object({}) do |extension, hash|
        hash[extension] = []
      end

      @tags = {}
    end
    
    def process(file_path_adapters:)
      file_path_adapters.each do |file_path, adapter|
        if (metadata = adapter&.metadata(file_path:))
          metadata.merge!({
            file_path:,
            file_type: File.extname(file_path).delete_prefix('.'),
            file_loaded: true,
          })
        else
          metadata = { file_loaded: false }
        end

        append(metadata:)
      end
    end

    def append(metadata:)
      @file_paths << metadata[:file_path]
      @file_types[metadata[:file_type]] = metadata[:file_path]

      metadata[:tags]&.each do |tag|
        @tags[tag] ||= []
        @tags[tag] = metadata[:file_path]
      end
    end
  end
end
