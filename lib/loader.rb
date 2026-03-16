# frozen_string_literal: true

module LowLoad
  class Loader
    class MissingDependencyError < StandardError; end

    class << self
      def add_autoloads(file_proxy:)
        autoloads = []

        file_proxy.dependencies.each do |namespace_with_dependency|
          *namespace, dependency = namespace_with_dependency.split('::')

          definition_proxies = find_definition_proxies(namespace:, dependency:)

          current_namespace = Object
          namespace.each do |module_name|
            current_namespace.const_set(module_name, Module.new) unless current_namespace.const_defined?(module_name)
            current_namespace = current_namespace.const_get(module_name)
          end

          definition_proxies.each do |definition_proxy|
            autoloads << { origin: file_proxy.file_path, current_namespace:, dependency:, file_path: definition_proxy.file_path }
            current_namespace.autoload(dependency.to_sym, definition_proxy.file_path)
          end
        end

        autoloads
      end

      def find_definition_proxies(namespace:, dependency:)
        return Lowkey[dependency] || raise(MissingDependencyError) if namespace.empty?

        namespace_with_dependency = [namespace, dependency].join('::')
        return Lowkey[namespace_with_dependency] if Lowkey[namespace_with_dependency]

        namespace.pop
        find_definition_proxies(namespace:, dependency:)
      end
    end
  end
end
