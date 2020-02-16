class UsersController < ApplicationController

    get '/login' do
        redirect to "/users/#{current_user.id}" if logged_in?
        erb :'users/login'
    end

    get '/logout' do
        session.destroy if logged_in?
        redirect to '/login'
    end

    get '/users/:id' do
        if logged_in? && params[:id] == current_user.id
          @user = User.find(session[:user_id])
          erb :'users/show'
        end
    end

    post '/login' do
        if !logged_in
          user = User.find_by(username: params[:username])
          if user && user.authenticate(params[:password])
              session[:user_id] = user.id
              redirect to "/users/#{user.id}"
          end
        else
            redirect to '/logout'
        end
    end
end