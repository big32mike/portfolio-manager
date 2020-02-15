class UsersController < ApplicationController

    get '/login' do
        erb :'users/login'
    end

    get '/logout' do

    end

    post '/login' do
        user = User.find_by(username: params[:username])
        if user && user.authenticate(params[:password])
            redirect to '/portfolios'
        end
    end
end