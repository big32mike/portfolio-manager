class PortfoliosController < ApplicationController

    get '/portfolios/new' do
        if logged_in?
            @portfolios = current_user.portfolios
            erb :'portfolios/new'
        else
            flash[:error] = "You must be logged in to create a new portfolio"
            redirect to '/login'
        end
    end

    get '/portfolios/:id' do
        if logged_in?
            @portfolio = Portfolio.find(params[:id])

            if authorized?(@portfolio)
                @portfolios = current_user.portfolios.select {|p| p.id != @portfolio.id}
                @stocks = @portfolio.stocks
                erb :'portfolios/show'
            else
                flash[:error] = "You are not authorized to view that portfolio"
                redirect to "/users/#{current_user.id}"
            end
        else
            flash[:error] = "You must be logged in to view a portfolio"
            redirect to '/login'
        end
    end

    post '/portfolios' do

        if params[:portfolio][:name] == ""
            flash[:error] = "Portfolio requires a name"
            redirect to '/portfolios/new'
        end

        if logged_in?
            portfolio = Portfolio.create(name: params[:portfolio][:name])
            current_user.portfolios << portfolio if portfolio
            redirect to "/portfolios/#{portfolio.id}"
        else
            flash[:error] = "You must be logged in to create a new portfolio"
            redirect to '/login'
        end

    end

    get '/portfolios/:id/edit' do
        @portfolio = Portfolio.find(params[:id])
        if authorized?(@portfolio)
            @portfolios = current_user.portfolios
            erb :'portfolios/edit'
        else
            flash[:error] = "You're not authorized to edit #{portfolio.name}"
            redirect to '/login'
        end
    end

    patch '/portfolios/:id' do
        portfolio = Portfolio.find(params[:id])
        if authorized?(portfolio)
            portfolio.name = params[:portfolio][:name]
            portfolio.save
            redirect to "/portfolios/#{portfolio.id}"
        end
    end

    delete '/portfolios/:id/delete' do
        portfolio = Portfolio.find(params[:id])
        if authorized?(portfolio)
            portfolio.stocks.each do |s|
                s.delete
            end
            portfolio.delete
            redirect to "/users/#{current_user.id}"
        end
        redirect to '/login'
    end

    delete '/portfolios/:id/stocks/:s_id/delete' do

        if logged_in?
            portfolio = Portfolio.find(params[:id])

            if authorized?(portfolio)
                stock = Stock.find(params[:s_id])
                stock.delete
                flash[:message] = "#{stock.symbol} deleted (#{stock.name})"
                redirect to "/portfolios/#{portfolio.id}"
            else
                flash[:error] = "You aren't authorized to delete that stock"
                redirect to "/users/#{current_user.id}"
            end

        else
            flash[:error] = "You must be logged in to delete a stock"
            redirect to '/login'
        end

    end
end