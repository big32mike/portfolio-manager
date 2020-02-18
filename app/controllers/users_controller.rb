class UsersController < ApplicationController

    get '/login' do
        redirect to "/users/#{current_user.id}" if logged_in?
        erb :'users/login'
    end

    get '/logout' do
        if logged_in?
          user = current_user
          session.destroy if logged_in?
          flash[:message] = "#{user.username} logged out"
        end
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
            else
                flash[:error] = "#{params[:username]} not authenticated"
                redirect to '/login'
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
        
        if params[:password] != params[:password2]
            flash[:error] = "Passwords must match"
            redirect to'/signup' 
        end
        
        user = User.find_by(username: params[:username])

        if user
            flash[:error] = "User #{user.username} already exists, please login"
            redirect to '/login'
        else
            user = User.create(username: params[:username], password: params[:password])
            session[:user_id] = user.id
            flash[:message] = "#{user.username} created"
            redirect to "/users/#{current_user.id}"
        end
    end
end