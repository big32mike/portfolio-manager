require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'you_gotta_diversify_your_bonds'
  end

  get "/" do
    erb :welcome
  end

end
