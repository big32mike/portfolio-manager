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
        # if current_user.id == @portfolio.user_id
        if authorized?(@portfolio)
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

            if params[:stock_ids]
                params[:stock_ids].each do |stock_id|
                    stocks << Stock.find(stock_id)
                end
            end

            if params[:stock][:symbol] != ""
                s_params = params[:stock]
                #stocks << Stock.create(symbol: params[:stock][:symbol])
                stocks << Stock.create(s_params)
            end

            portfolio.stocks = stocks
            current_user.portfolios << portfolio
            redirect to "/portfolios/#{portfolio.id}"
        else
            redirect to '/login' # flash[:error] = "You must be logged in to create a new portfolio"
        end
    end

    get '/portfolios/:id/edit' do
        @portfolio = Portfolio.find(params[:id])
        if authorized?(@portfolio)
            @portfolios = current_user.portfolios
            @stocks = Stock.all
            erb :'portfolios/edit'
        else
            # flash[:error] = "You're not authorized to edit this portfolio"
            redirect to '/login'
        end
    end

    patch '/portfolios/:id' do
        portfolio = Portfolio.find(params[:id])
        if authorized?(portfolio)
            stocks = []
            portfolio.name = params[:portfolio][:name]

            #fbinding.pry
            if params[:stock_ids]
                params[:stock_ids].each do |stock_id|
                    stocks << Stock.find(stock_id)
                end
            else
                portfolio.stocks.clear
            end

            if params[:stock][:symbol] != "" && params[:stock][:name] != "" && params[:stock][:asset_class] != ""
                stocks << Stock.create(params[:stock])
            end
            
            portfolio.stocks << stocks
            portfolio.save
            redirect to "/portfolios/#{portfolio.id}"
        end
    end

    delete '/portfolios/:id/delete' do
        portfolio = Portfolio.find(params[:id])
        if authorized?(portfolio)
            portfolio.delete
        else
            # flash[:error] = "You're not authorized to delete this Portfolio"
        end
        redirect to '/login'
    end
end