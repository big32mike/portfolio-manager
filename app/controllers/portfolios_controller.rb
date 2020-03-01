class PortfoliosController < ApplicationController

    get '/portfolios/new' do
        if logged_in?
            @portfolios = current_user.portfolios
            @stocks = Stock.all
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
                stocks << Stock.create(s_params)
            end

            portfolio.stocks = stocks
            current_user.portfolios << portfolio
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
            stocks = []
            portfolio.name = params[:portfolio][:name]

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
            flash[:error] = "You're not authorized to delete #{portfolio.name}"
        end
        redirect to '/login'
    end
end