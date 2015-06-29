# encoding: UTF-8

module Rosette
  module DataStores
    class InMemoryDataStore
      class Translation < Model
        extend ExtractParams

        ATTRIBUTES = [:phrase_id, :locale, :translation]

        validates :translation, presence: true
        validates :phrase_id, presence: true
        validates :locale, presence: true

        def phrase
          Phrase.find do |phrase|
            phrase_id == phrase.id
          end
        end

      end
    end
  end
end
