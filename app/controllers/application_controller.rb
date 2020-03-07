require './config/environment'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'you_gotta_diversify_your_bonds'
    register Sinatra::Flash
  end

  get "/" do
    erb :welcome
  end

  helpers do

    def logged_in?
      !!session[:user_id]
    end

    def current_user
      # instance variable minimizes db calls
      @current_user ||= User.find(session[:user_id])
    end

    def authorized?(portfolio)
      current_user.id == portfolio.user_id
    end

    def stock_portfolio(stock)
      Portfolio.find(stock.portfolio_id)
    end
  end

end
