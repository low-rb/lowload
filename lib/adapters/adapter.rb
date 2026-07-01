# frozen_string_literal: true

module LowLoad
  class Adapter
    def extensions
      raise NotImplementedError, "Specify a file extension"
    end

    def metadata(file_path:)
    end

    def preload(file_path:)
    end

    def evaluate(file_path:, top_level_binding: nil)
    end
  end
end
