# frozen_string_literal: true

require_relative 'adapters/markdown_adapter'

module LowLoad
  class Metadata
    EXTENSIONS = [
      *::LowLoad::MarkdownAdapter::EXTENSIONS,
      *::LowLoad::RBXAdapter::EXTENSIONS,
      *::LowLoad::RubyAdapter::EXTENSIONS,
    ]

    attr_accessor :loaded_paths, :missed_paths, :file_types, :url_paths, :tags

    def initialize
      @loaded_paths = []
      @missed_paths = []

      @file_types = EXTENSIONS.each_with_object({}) { |extension, hash| hash[extension] = [] }
      @url_paths = {}
      @tags = {}
    end

    def process(file_path_adapters:)
      file_path_adapters.each do |file_path, adapter|
        if (metadata = adapter&.metadata(file_path:))
          append(file_path:, adapter:, metadata:)
        else
          @missed_paths << file_path
        end
      end
    end

    def append(file_path:, adapter:, metadata:)
      @loaded_paths << file_path
      @file_types[File.extname(file_path).delete_prefix('.')] = file_path
      @url_paths[adapter.url_path(file_path:)] = file_path

      metadata[:tags]&.each do |tag|
        @tags[tag] ||= []
        @tags[tag] = file_path
      end
    end
  end
end
