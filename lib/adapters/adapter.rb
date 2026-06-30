# frozen_string_literal: true

module LowLoad
  class Adapter
    def extensions
      raise NotImplementedError, "Specify a file extension"
    end

    def map_load(file_path:)
    end

    def pre_load(file_path:)
    end

    def low_load(file_path:, top_level_binding: nil)
    end
  end
end
