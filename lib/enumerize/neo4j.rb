module Enumerize
  module Neo4jSupport
    def enumerize(name, options={})
      super

      _enumerize_module.dependent_eval do
        if self < ::Neo4j::ActiveNode || self < ::Neo4j::ActiveRel
          after_initialize :_set_default_value_for_enumerized_attributes
        end
      end
    end
  end
end
