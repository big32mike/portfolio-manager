class UsersController < ApplicationController

    get '/login' do
        erb :'users/login'
    end

    get '/logout' do

    end

    post '/login' do
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            erb :'users/home'
        end
    end
end