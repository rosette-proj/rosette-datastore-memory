# encoding: UTF-8

module Rosette
  module DataStores
    class InMemoryDataStore

      autoload :ExtractParams,   'rosette/data_stores/in_memory/models/extract_params'
      autoload :Model,           'rosette/data_stores/in_memory/models/model'
      autoload :Phrase,          'rosette/data_stores/in_memory/models/phrase'
      autoload :CommitLog,       'rosette/data_stores/in_memory/models/commit_log'
      autoload :CommitLogLocale, 'rosette/data_stores/in_memory/models/commit_log_locale'
      autoload :Translation,     'rosette/data_stores/in_memory/models/translation'

    end
  end
end
