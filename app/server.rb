require 'sinatra/base'
require 'data_mapper'
require 'bcrypt'
require 'rack-flash'
require_relative '../lib/link.rb'
require_relative '../lib/tag.rb'
require_relative '../lib/user.rb'
require_relative 'database_setup'
require_relative 'helpers/current_user'

class BookmarkManager < Sinatra::Base

  include CurrentUser

  use Rack::Flash
  use Rack::MethodOverride

  set :public_dir, Proc.new {File.join(root, '..', 'public')}
  set :public_folder, 'public'

  enable :sessions
  set :session_secret, 'super secret'

  get '/' do
    @links = Link.all
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

  get '/sessions/new' do
    erb :"sessions/new"
  end

  post '/sessions' do
    email, password = params[:email], params[:password]
    user = User.authenticate(email, password)
    if user
      session[:user_id] = user.id
      redirect '/'
    else
      flash[:errors] = ['The email or password is incorrect']
      erb :"sessions/new"
    end
  end

  delete '/sessions' do
    flash[:notice] = 'Good bye!'
    session[:user_id] = nil
    redirect '/'
  end

end