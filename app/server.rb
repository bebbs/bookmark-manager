require 'sinatra/base'
require 'data_mapper'

class BookmarkManager < Sinatra::Base

  env = ENV['RACK_ENV'] || 'development'

  DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
  require_relative '../lib/link.rb'
  DataMapper.finalize
  DataMapper.auto_upgrade!

  get '/' do
    erb :index
  end

end