# encoding: UTF-8

module Rosette
  module DataStores
    class InMemoryDataStore

      class CommitLog < Model
        include Rosette::Core::CommitLogStatus

        STATUSES = Rosette::DataStores::PhraseStatus.constants.map(&:to_s)

        validates :commit_id, presence: true
        validates :status, inclusion: { in: STATUSES }

        def commit_log_locales
          CommitLogLocale.select do |entry|
            entry.commit_id == commit_id
          end
        end
      end

    end
  end
end
