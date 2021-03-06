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

      def store_phrase(repo_name, phrase)
        phrase_entry = Phrase.find do |entry|
          entry.repo_name == repo_name &&
            entry.key == phrase.key &&
            entry.meta_key == phrase.meta_key &&
            entry.file == phrase.file &&
            entry.commit_id == phrase.commit_id &&
            entry.author_name == phrase.author_name &&
            entry.author_email == phrase.author_email
        end

        phrase_entry ||= Phrase.create(
          repo_name: repo_name,
          key: phrase.key,
          meta_key: phrase.meta_key,
          file: phrase.file,
          commit_id: phrase.commit_id,
          author_name: phrase.author_name,
          author_email: phrase.author_email
        )
      end

      def phrases_by_commit(repo_name, commit_id, file = nil)
        Phrase.select do |phrase|
          matches = phrase.repo_name == repo_name &&
            phrase.commit_id == commit_id

          matches &&= phrase.file == file if file
          matches
        end
      end

      def phrases_by_commits(repo_name, commit_id_map)
        if block_given?
          if commit_id_map.is_a?(Array)
            phrases = Phrase.select do |phrase|
              commit_id_map.include?(phrase.commit_id)
            end

            phrases.each { |phrase| yield phrase }
          else
            phrases = Phrase.select do |phrase|
              commit_id_map[phrase.file] &&
                commit_id_map[phrase.file] == phrase.commit_id
            end

            phrases.each { |phrase| yield phrase }
          end
        else
          to_enum(__method__, repo_name, commit_id_map)
        end
      end

      def lookup_phrase(repo_name, key, meta_key, commit_id)
        commit_ids = Array(commit_id)

        Phrase.lookup(key, meta_key).select do |entry|
          commit_ids.include?(entry.commit_id) &&
            entry.repo_name == repo_name
        end.first
      end

      def lookup_commit_log(repo_name, commit_id)
        CommitLog.find do |entry|
          entry.repo_name == repo_name && entry.commit_id == commit_id
        end
      end

      def add_or_update_commit_log(repo_name, commit_id, commit_datetime = nil, status = Rosette::DataStores::PhraseStatus::NOT_SEEN, phrase_count = nil, branch_name = nil)
        log_entry = CommitLog.find do |entry|
          entry.repo_name == repo_name &&
            entry.commit_id == commit_id
        end

        log_entry ||= CommitLog.create(
          repo_name: repo_name, commit_id: commit_id, status: nil
        )

        log_entry.merge_attributes(status: status)
        log_entry.merge_attributes(phrase_count: phrase_count) if phrase_count
        log_entry.merge_attributes(commit_datetime: commit_datetime) if commit_datetime
        log_entry.merge_attributes(branch_name: branch_name) if branch_name

        unless log_entry.valid?
          raise Rosette::DataStores::Errors::CommitLogUpdateError,
            "Unable to update commit #{commit_id}: #{log_entry.errors.full_messages.first}"
        end
      end

      def each_commit_log_with_status(repo_name, status, branch_name = nil, &blk)
        if block_given?
          statuses = Array(status)

          CommitLog.select do |entry|
            statuses.include?(entry.status) &&
              entry.repo_name == repo_name &&
              branch_name == nil || entry.branch_name == branch_name
          end.each(&blk)
        else
          to_enum(__method__, repo_name, status, branch_name)
        end
      end

      def commit_log_with_status_count(repo_name, status, branch_name = nil)
        statuses = Array(status)
        CommitLog.select do |entry|
          statuses.include?(entry.status) &&
            entry.repo_name == repo_name &&
            branch_name == nil || entry.branch_name == branch_name
        end.count
      end

      def add_or_update_commit_log_locale(commit_id, locale, translated_count)
        commit_log_locale_entry = CommitLogLocale.find do |entry|
          entry.commit_id == commit_id &&
            entry.locale == locale
        end

        commit_log_locale_entry ||= CommitLogLocale.create(
          commit_id: commit_id, locale: locale
        )

        commit_log_locale_entry.merge_attributes(
          translated_count: translated_count
        )

        unless commit_log_locale_entry.valid?
          raise Rosette::DataStores::Errors::CommitLogLocaleUpdateError,
            "Unable to update commit log locale #{commit_id} #{locale}: #{commit_log_locale_entry.errors.full_messages.first}"
        end
      end

      def commit_log_locales_for(repo_name, commit_id)
        entry = CommitLog.find do |entry|
          entry.repo_name == repo_name &&
            entry.commit_id == commit_id
        end

        entry.commit_log_locales
      end

      def commit_log_exists?(repo_name, commit_id)
        !!CommitLog.find do |entry|
          entry.repo_name == repo_name &&
            entry.commit_id == commit_id
        end
      end

      def each_unique_meta_key(repo_name)
        if block_given?
          Phrase
            .select { |phrase| phrase.repo_name == repo_name }
            .uniq { |p| p.meta_key }
        else
          to_enum(__method__, repo_name)
        end
      end

      def most_recent_key_for_meta_key(repo_name, meta_key)
        Phrase
          .select do |phrase|
            phrase.repo_name == repo_name && phrase.meta_key == meta_key
          end
          .sort do |p1, p2|
            p2.commit_datetime <=> p1.commit_datetime
          end
          .first
      end

      protected

      def percentage(dividend, divisor)
        if divisor > 0
          (dividend.to_f / divisor.to_f).round(2)
        else
          0.0
        end
      end
    end

  end
end
