# encoding: UTF-8

module Rosette
  module DataStores
    class InMemoryDataStore

      module ExtractParams

        def extract_params_from(params = {})
          self::ATTRIBUTES.each_with_object({}) do |column, ret|
            column_sym = column.to_sym

            if params.include?(column_sym)
              ret[column_sym] = params[column_sym]
            end
          end
        end

      end
    end
  end
end
