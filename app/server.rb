require 'sinatra/base'
require 'data_mapper'
require 'bcrypt'
require 'rack-flash'
require_relative '../lib/link.rb'
require_relative '../lib/tag.rb'
require_relative '../lib/user.rb'
require_relative 'database_setup'
require_relative 'helper_module'


class BookmarkManager < Sinatra::Base

  include HelperModule

  use Rack::Flash

  enable :sessions
  set :session_secret, 'super secret'

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

  get '/tags/:text' do
    tag = Tag.first(:text => params[:text])
    @links = tag ? tag.links : []
    erb :index
  end

  get '/users/new' do
    @user = User.new
    erb :"users/new"
  end

  post '/users' do
    @user = User.new(:email => params[:email], 
                       :password => params[:password], 
                       :password_confirmation => params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect '/'
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :"users/new"
    end
  end

end