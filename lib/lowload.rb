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
        load_rbx(file_path)
      end
    end

    private

    def load_rbx(file_path)
      # 1. "File Load" phase.
      file_proxy = Lowkey[file_path] || Lowkey.load(file_path)
      templates = wrap_render_methods(file_proxy:)

      # 2. "Class Load" phase.
      # Not a security risk because "eval" is equivalent to "load" or "require_relative" in this context.
      eval(file_proxy.export, top_level_binding, file_proxy.file_path, 0) # rubocop:disable Security/Eval

      # 3. "Runtime" phase (before LowNode instances are rendered).
      # Templates only exist if antlers gem has been required by another gem (such as LowNode) and the template contains antlers syntax.
      templates.each do |namespace, template|
        klass = const_get(namespace)

        next unless supports_templates?(klass)

        klass.add_template(parser: Antlers, ast: Antlers.parse(template), template:, namespace:)
      end
    end

    def supports_templates?(klass)
      klass.respond_to?(:render) && klass.respond_to?(:template) && klass.respond_to?(:add_template)
    end

    def wrap_render_methods(file_proxy:)
      # GOAL: Templates could be organised by method and template rendering engine.
      templates = {}

      file_proxy.definitions.each_value do |class_proxy|
        render_method = class_proxy.respond_to?(:instance_methods) ? class_proxy.instance_methods[:render] : nil

        next unless render_method

        render_method_body = render_method.body.export

        if defined?(Antlers) && ['{', '<{'].any? { |needle| render_method_body.include?(needle) }
          templates[class_proxy.namespace] = render_method_body
        end

        # Intended to target HTML or Antlers tags. Use HEREDOC "<<~" in a plain Ruby (".rb") file, not RBX.
        if render_method_body.strip.start_with?('<')
          render_method.body.wrap(prefix: '%q{', suffix: '}')
        end
      end

      templates
    end
  end
end
