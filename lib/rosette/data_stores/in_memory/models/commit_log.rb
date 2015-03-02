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

        def status=(new_status)
          super

          if new_status
            aasm.set_current_state_with_persistence(
              new_status.to_sym
            )
          end
        end

        def status
          aasm.current_state.to_s
        end
      end

    end
  end
end
