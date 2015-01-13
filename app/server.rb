require 'sinatra/base'
require 'data_mapper'
require 'link'
require 'tag'

class BookmarkManager < Sinatra::Base

  env = ENV['RACK_ENV'] || 'development'

  DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
  require_relative '../lib/link.rb'
  DataMapper.finalize
  DataMapper.auto_upgrade!

  get '/' do
    @links= Link.all
    erb :index
  end

  post '/links' do
    url = params[:url]
    title = params[:title]
    tags = params[:tags].split(' ').map do |tag|
      Tag.first_or_create(:text => tag)
    end
    Link.create(:url => url, :title => title, :tags => tags)
    redirect '/'
  end

end