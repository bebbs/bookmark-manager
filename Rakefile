require 'data_mapper'
require './app/database_setup'

task :auto_upgrade do
  
  # auto_upgrade makes non-destructive changes.
  # If tables don't exist, they will be created.
  # If they do exist, and the schema has been changed,
  # they will not be upgraded because that will lead
  # to data loss.

  DataMapper.auto_upgrade!
  puts "Auto-upgrade complete (no data loss)"

end

task :auto_migrate do

  # To force the creation of all tables as they are 
  # described in the models, even if this may lead
  # to data loss, use auto_migrate.

  DataMapper.auto_migrate!
  puts "Auto-migrate complete (data could have been lost)"
  
end