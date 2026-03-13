# frozen_string_literal: true

require 'lowkey'

def top_level_binding
  binding
end

module LowLoad
  class << self
    def dirload(path, pwd = Dir.pwd)
      absolute_path = File.expand_path(path, pwd)
      file_paths = Dir["#{absolute_path}/**/*"]
      
      file_paths.each do |file_path|
        lowload(file_path)
      end
    end

    def lowload(file_path, pwd = Dir.pwd)
      file_path = File.expand_path(file_path, pwd)
      extension = File.extname(file_path).delete_prefix('.')

      file_proxy = Lowkey.load(file_path)
      case extension
      when 'rb'
        load(file_path)
      when 'rbx'
        load_rbx(file_proxy)
      end
    end

    private

    def load_rbx(file_path)
      file_proxy.definitions.each_value do |class_proxy|
        next unless class_proxy[:render]

        class_proxy[:render].body.wrap(prefix: '%q{', suffix: '}')
      end

      # Not a security risk because "eval" is equivalent to "load" or "require_relative" in this context.
      eval(file_proxy.export, top_level_binding, file_proxy.file_path, 0) # rubocop:disable Security/Eval
    end
  end
end
