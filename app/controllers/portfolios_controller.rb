class PortfoliosController < ApplicationController

    get '/portfolios/new' do
        if logged_in?
            @portfolios = current_user.portfolios
            @stocks = Stock.all
            erb :'portfolios/new'
        else
            redirect to '/login' # flash[:error] = "You must be logged in to create a new portfolio"
        end
    end

    get '/portfolios/:id' do
        @portfolio = Portfolio.find(params[:id])
        if current_user.id == @portfolio.user_id
            @portfolios = current_user.portfolios.select {|p| p.id != @portfolio.id}
            @stocks = @portfolio.stocks
            erb :'portfolios/show'
        elsif logged_in?
            redirect to "/users/#{current_user.id}" # flash[:error] = "You are not authorized to view that portfolio"
        else
            redirect to '/login' # flash[:error] = "You must be logged in to view a portfolio"
        end
    end

    post '/portfolios' do
        #binding.pry
        if logged_in?
            stocks = []
            portfolio = Portfolio.create(name: params[:portfolio][:name])

            if params[:stock][:ids]
                params[:stock][:ids].each do |stock_id|
                    stocks << Stock.find(stock_id)
                end
            end

            if params[:stock][:symbol] != ""
                stocks << Stock.create(symbol: params[:stock][:symbol])
            end

            portfolio.stocks = stocks
            current_user.portfolios << portfolios
            redirect to "/portfolios/#{portfolio.id}"
        else
            redirect to '/login' # flash[:error] = "You must be logged in to create a new portfolio"
        end
    end
end