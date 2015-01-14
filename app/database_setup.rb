env = ENV['RACK_ENV'] || 'development'

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
require_relative '../lib/link.rb'

DataMapper.auto_upgrade!
# DataMapper.auto_migrate!

DataMapper.finalize