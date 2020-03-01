class StocksController < ApplicationController

    get '/stocks' do
        if !logged_in?
            flash[:error] = "You must be logged in to view stocks"
            redirect to '/login'

        else
            @all_stocks = []
            portfolios = current_user.portfolios

            if !portfolios.empty?
                portfolios.each do |portfolio|
                    portfolio.stocks.each do |stock|
                        @all_stocks << stock
                    end
                end
            end

            erb :'stocks/index'
        end
    end

    post '/stocks' do
        if params[:stock].values.any? {|s| s == ""}
            flash[:error] = "All fields required to create new stock"
            redirect to "/portfolios/#{params[:portfolio][:id]}"
        end

        if logged_in?
            portfolio = Portfolio.find(params[:portfolio][:id])

            if authorized?(portfolio)
                stock = Stock.create(params[:stock])
                portfolio.stocks << stock
                flash[:message] = "Stock #{stock.symbol} created"
                redirect to "/portfolios/#{portfolio.id}"
            else
                flash[:error] = "You're not authorized to create stock in this portfolio"
                redirect "/users/#{current_user.id}"
            end

        else
            flash[:error] = "You must be logged in to create a stock"
            redirect to '/login'
        end
    end

    get '/stocks/:id/edit' do
        if logged_in?
            @stock = Stock.find(params[:id])
            @portfolio = stock_portfolio(@stock)

            if authorized?(@portfolio)
                erb :'stocks/edit'
            else
                flash[:error] = "You aren't authorized to edit that stock"
                redirect to "/users/#{current_user.id}"
            end

        else
            flash[:error] = "You must be logged in to edit a stock"
            redirect to '/login'
        end
    end

    patch '/stocks/:id' do
        stock = Stock.find(params[:id])
        if logged_in?
            portfolio = stock_portfolio(stock)
            if authorized?(portfolio)

                if params.values.all? { |value| value != ""}
                    stock.name = params[:name]
                    stock.price = params[:price]
                    stock.symbol = params[:symbol]
                    stock.quantity = params[:quantity]
                    stock.asset_class = params[:asset_class]
                    stock.save
                    flash[:message] = "#{stock.symbol} updated"
                    redirect to "/portfolios/#{portfolio.id}"
                end

                flash[:error] = "All fields required to update stock"
                redirect to "/stocks/#{stock.id}/edit"

            else
                flash[:error] = "You're not authorized to edit this stock"
                redirect to "/users/#{current_user.id}"
            end

        else
            flash[:error] = "You must be logged in to edit stocks"
        end
    end
end