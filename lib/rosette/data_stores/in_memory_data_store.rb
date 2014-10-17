# encoding: UTF-8

require 'active_model'
require 'rosette/data_stores'
require 'rosette/data_stores/phrase_status'
require 'rosette/data_stores/in_memory/models'

module Rosette
  module DataStores

    class InMemoryDataStore
      def initialize(options = {})
      end

      def self.all_entries
        @entries ||= Hash.new { |h, key| h[key] = [] }
      end

      def phrases_by_commit(repo_name, commit_id, file = nil)
        Phrase.select do |phrase|
          matches = phrase.repo_name == repo_name &&
            phrase.commit_id == commit_id

          matches &&= phrase.file == file if file
          matches
        end
      end

      def add_or_update_commit_log(repo_name, commit_id, status = Rosette::DataStores::PhraseStatus::UNTRANSLATED, phrase_count = nil)
        log_entry = CommitLog.find do |entry|
          entry.repo_name == repo_name &&
            entry.commit_id == commit_id
        end

        log_entry ||= CommitLog.create(
          repo_name: repo_name, commit_id: commit_id
        )

        log_entry.merge_attributes(status: status)
        log_entry.merge_attributes(phrase_count: phrase_count) if phrase_count

        unless log_entry.valid?
          raise Rosette::DataStores::Errors::CommitLogUpdateError,
            "Unable to update commit #{commit_id}: #{log_entry.errors.full_messages.first}"
        end
      end

      def add_or_update_commit_log_locale(commit_id, locale, translated_count)
        commit_log_locale_entry = CommitLogLocale.find do |entry|
          entry.commit_id == commit_id &&
            entry.locale == locale
        end

        commit_log_locale_entry ||= CommitLogLocale.create(
          cmomit_id: commit_id, locale: locale
        )

        commit_log_locale_entry.merge_attributes(
          translated_count: translated_count
        )

        unless commit_log_locale_entry.valid?
          raise Rosette::DataStores::Errors::CommitLogLocaleUpdateError,
            "Unable to update commit log locale #{commit_id} #{locale}: #{commit_log_locale_entry.errors.full_messages.first}"
        end
      end
    end

  end
end
