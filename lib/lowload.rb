# frozen_string_literal: true

require 'lowkey'

module LowLoad
  class << self
    def load(file_path)
      file_proxy = Lowkey.load(file_path)
    end
  end
end
