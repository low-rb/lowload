# frozen_string_literal: true

require 'lowkey'
require_relative 'adapter'
require_relative '../loader'

def top_level_binding
  binding
end

module LowLoad
  class RBXAdapter < Adapter
    def extensions = ['rbx']

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
      # 1. "File Load" phase.
      file_proxy = Lowkey[file_path] || Lowkey.load(file_path)
      templates = wrap_render_methods(file_proxy:)

      # 2. "Class Load" phase.
      # Not a security risk because "eval" is equivalent to "load" or "require_relative" in this context.
      eval(file_proxy.export, top_level_binding, file_proxy.file_path, 0) # rubocop:disable Security/Eval

      # 3. "Runtime" phase (before low nodes are rendered).
      # Templates only exist if antlers gem has been required by another gem (such as LowNode) and the template contains antlers syntax.
      templates.each do |namespace, method_template|
        klass = Object.const_get(namespace)
        method, template = method_template
        # TODO: If params contain "**props" or similar then send that, so that LowNode can replicate it.
        params = method.params.map(&:name)

        next unless supports_templates?(klass) || raise(UnsupportedTemplate, "Template for '#{namespace}' identified but not implemented")

        # TODO: Make template engine configurable.
        klass.build_template(template:, params:, engine: Antlers, namespace:)
      end
    end

    private

    def supports_templates?(klass)
      klass.respond_to?(:render) && klass.respond_to?(:template) && klass.respond_to?(:build_template)
    end

    def wrap_render_methods(file_proxy:)
      # GOAL: Templates could be organised by method and template rendering engine.
      templates = {}

      file_proxy.definitions.each_value do |class_proxy|
        render_method = class_proxy.respond_to?(:instance_methods) ? class_proxy.instance_methods[:render] : nil

        next unless render_method

        render_method_body = render_method.body.export

        if defined?(Antlers) && ['{', '<{'].any? { |needle| render_method_body.include?(needle) }
          templates[class_proxy.namespace] = [render_method, render_method_body]
        end

        # Intended to target HTML or Antlers tags. Use HEREDOC "<<~" in a plain Ruby (".rb") file, not RBX.
        render_method.body.wrap(prefix: '%q{', suffix: '}') if render_method_body.strip.start_with?('<')
      end

      templates
    end
  end
end
