# encoding: UTF-8

module Rosette
  module DataStores
    class InMemoryDataStore

      class Model
        attr_reader :attributes

        include ActiveModel::Validations

        class << self

          include Enumerable

          def create(attributes = {})
            new_model = new(attributes)
            entries << new_model
            new_model
          end

          alias :from_h :create

          def each(&block)
            entries.each(&block)
          end

          def entries
            InMemoryDataStore.all_entries[name]
          end

        end

        def initialize(attributes = {})
          @attributes = {}
          merge_attributes(attributes)
        end

        def method_missing(method, *args, &block)
          setter = method.to_s.end_with?('=')
          method = method.to_s.chomp('=').to_sym

          if setter
            attributes[method] = args.first
          else
            if attributes.include?(method)
              attributes[method]
            else
              raise NoMethodError, "no method #{method} for #{self.class.name}"
            end
          end
        end

        def merge_attributes(new_attrs)
          new_attrs.each_pair do |key, value|
            send("#{key}=", value)
          end
        end
      end

    end
  end
end
