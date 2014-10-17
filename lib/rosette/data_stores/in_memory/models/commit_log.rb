# encoding: UTF-8

module Rosette
  module DataStores
    class InMemoryDataStore

      class CommitLog < Model
        STATUSES = Rosette::DataStores::PhraseStatus.constants.map(&:to_s)

        validates :commit_id, presence: true
        validates :status, inclusion: { in: STATUSES }
      end

    end
  end
end
