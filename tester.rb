require 'rosette/data_stores/in_memory_data_store'
require 'pry-nav'

datastore = Rosette::DataStores::InMemoryDataStore.new

datastore.add_or_update_commit_log('foobar', 'abc123')
binding.pry
