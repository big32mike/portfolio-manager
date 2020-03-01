class StocksController < ApplicationController
    
    get '/stocks' do
        @stocks = Stock.all
        erb :'stocks/index'
    end

    post '/stocks' do
        if logged_in?
            portfolio = Portfolio.find(params[:portfolio][:id])
            stock = Stock.create(params[:stock])
            if !Stock.all.include?(stock)
                flash[:error] = "Invalid input"
                redirect to "/portfolios/#{portfolio.id}"
            end

            if authorized?(portfolio)
                portfolio.stocks << stock
                portfolio.save
                flash[:message] = "Stock #{stock.symbol} created"
                redirect to "/portfolios/#{portfolio.id}"
            end
        else
            flash[:error] = "You must be logged in to create a stock"
            redirect to '/login'
        end
    end

    get '/stocks/:id/edit' do
        if logged_in?
            @stock = Stock.find(params[:id])
            erb :'stocks/edit'
        else
            flash[:error] = "You must be logged in to edit a stock"
            redirect to '/login'
        end
    end

    patch '/stocks/:id' do
        stock = Stock.find(params[:id])
        if params[:symbol] != "" && params[:name] != "" && params[:asset_class] != ""
            stock.symbol = params[:symbol]
            stock.name = params[:name]
            stock.asset_class = params[:asset_class]
            stock.save
            flash[:message] = "#{stock.symbol} updated"
        end
        redirect to '/stocks'
    end
end