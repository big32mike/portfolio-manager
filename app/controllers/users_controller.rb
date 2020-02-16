class UsersController < ApplicationController

    get '/login' do
        erb :'users/login'
    end

    get '/logout' do

    end

    get '/users/:id' do
        @user = User.find(session[:user_id])
        erb :'users/show'
    end

    post '/login' do
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect to "/users/#{@user.id}"
        end
    end
end