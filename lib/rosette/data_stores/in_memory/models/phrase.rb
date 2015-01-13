# encoding: UTF-8

module Rosette
  module DataStores
    class InMemoryDataStore

      class Phrase < Model
        include Rosette::Core::PhraseIndexPolicy
        include Rosette::Core::PhraseToHash

        validates :repo_name, presence: true
        validates :key, presence: true
        validates :file, presence: true
        validates :commit_id, presence: true

        class << self

          @@id = 0

          def lookup(key, meta_key)
            ikey = index_key(key, meta_key)
            ivalue = index_value(key, meta_key)
            select do |entry|
              entry.send(ikey) == ivalue
            end
          end

          def create(attributes)
            super(attributes.merge( { id: id_increment } ))
          end

          def id_increment
            @@id += 1
          end
        end

        def translations
          Translation.select do |entry|
            entry.commit_id == commit_id
          end
        end
      end
    end
  end
end
