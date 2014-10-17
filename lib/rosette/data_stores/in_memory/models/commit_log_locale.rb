# encoding: UTF-8

module Rosette
  module DataStores
    class InMemoryDataStore

      class CommitLogLocale < Model
        validates :commit_id, presence: true
        validates :locale, presence: true
      end

    end
  end
end
