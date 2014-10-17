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
      end

    end
  end
end
