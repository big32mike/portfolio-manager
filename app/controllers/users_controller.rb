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
        if logged_in? && params[:id].to_i == current_user.id
          @user = User.find(session[:user_id])
          erb :'users/show'
        end
    end

    post '/login' do
        if !logged_in?
          user = User.find_by(username: params[:username])
          if user && user.authenticate(params[:password])
              session[:user_id] = user.id
              redirect to "/users/#{user.id}"
          end
        else
            redirect to '/logout'
        end
    end

    get '/signup' do
        redirect to "/users/#{current_user.id}" if logged_in?
        erb :'users/new'
    end

    post '/signup' do
        redirect to '/logout' if logged_in?
        redirect to'/signup' if params[:password] != params[:password2] # flash[:error] = "Passwords must match"
        user = User.find_by(username: params[:username])
        if user
            redirect to '/login' #flash[:error] = "User #{user.username} already exists, please login"
        else
            user = User.create(username: params[:username], password: params[:password])
            session[:user_id] = user.id
            redirect to "/users/#{current_user.id}"
        end
    end
end