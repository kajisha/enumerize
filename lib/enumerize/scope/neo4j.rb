module Enumerize
  module Scope
    module Neo4j
      def enumerize(name, options={})
        super

        _enumerize_module.dependent_eval do
          if self < ::Neo4j::ActiveNode || self < ::Neo4j::ActiveRel
            if options[:scope]
              _define_neo4j_scope_methods!(name, options)
            end
          end
        end
      end

      private

      def _define_neo4j_scope_methods!(name, options)
        scope_name = options[:scope] == true ? "with_#{name}" : options[:scope]

        define_singleton_method scope_name do |*values|
          values = enumerized_attributes[name].find_values(*values).map(&:value)

          where(name => values)
        end

        if options[:scope] == true
          define_singleton_method "without_#{name}" do |*values|
            values = enumerized_attributes[name].find_values(*values).map(&:value)

            where_not(name => values)
          end
        end
      end
    end
  end
end
