# encoding: UTF-8

module Rosette
  module DataStores
    class InMemoryDataStore

      autoload :Model,           'rosette/data_stores/in_memory/models/model'
      autoload :Phrase,          'rosette/data_stores/in_memory/models/phrase'
      autoload :CommitLog,       'rosette/data_stores/in_memory/models/commit_log'
      autoload :CommitLogLocale, 'rosette/data_stores/in_memory/models/commit_log_locale'

    end
  end
end
