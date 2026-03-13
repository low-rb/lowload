# frozen_string_literal: true

require 'lowkey'

def top_level_binding
  binding
end

module LowLoad
  class << self
    def load(file_path, pwd = Dir.pwd)
      file_path = File.expand_path(file_path, pwd)
      extension = File.extname(file_path).delete_prefix('.')

      case extension
      when 'rb'
        load(file_path)
      when 'rbx'
        load_rbx(file_path)
      end
    end

    private

    def load_rbx(file_path)
      file_proxy = Lowkey.load(file_path)

      file_proxy.definitions.each_value do |class_proxy|
        next unless class_proxy[:render]

        class_proxy[:render].body.wrap(prefix: '%q{', suffix: '}')
      end

      # Not a security risk because "eval" is equivalent to "load" or "require_relative" in this context.
      eval(file_proxy.export, top_level_binding, file_path, 0) # rubocop:disable Security/Eval
    end
  end
end
