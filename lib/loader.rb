# frozen_string_literal: true

module LowLoad
  class Loader
    class << self
      # Dependencies and definitions are simply string representations of namespaces.
      def autoload_dependencies(file_proxy:)
        file_proxy.dependencies.each do |dependency_namespace|
          definition_namespace = find_definition_namespace(dependency_namespace: dependency_namespace.split('::'))

          Lowkey[definition_namespace].each do |definition_file_proxy|
            binding.pry
            autoload(const_get("::#{definition_namespace}"), definition_file_proxy.file_path)
          end
        end
      end

      def find_definition_namespace(dependency_namespace:)
        return nil if dependency_namespace.count == 1

        dependency_namespace.delete_at(-2)

        definition_namespace = dependency_namespace.join('::')
        return definition_namespace if Lowkey[definition_namespace]

        find_definition_namespace(dependency_namespace:)
      end
    end
  end
end
