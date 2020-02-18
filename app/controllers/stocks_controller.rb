class StocksController < ApplicationController
    
    get '/stocks' do
        @stocks = Stock.all
        erb :'stocks/index'
    end

    post '/stocks' do
        portfolio = Portfolio.find(params[:portfolio][:id])

        if params[:stock][:symbol] != "" && params[:stock][:name] != "" && params[:stock][:asset_class] != ""
            stock = Stock.create(params[:stock])
        end

        if authorized?(portfolio)
            portfolio.stocks << stock
            portfolio.save
            redirect to "/portfolios/#{portfolio.id}"
        end

        redirect to '/stocks'
    end

    get '/stocks/:id/edit' do
        @stock = Stock.find(params[:id])
        erb :'stocks/edit'
    end

    patch '/stocks/:id' do
        stock = Stock.find(params[:id])
        if params[:symbol] != "" && params[:name] != "" && params[:asset_class] != ""
            stock.symbol = params[:symbol]
            stock.name = params[:name]
            stock.asset_class = params[:asset_class]
            stock.save
        end
        redirect to '/stocks'
    end

    delete '/stocks/:id/delete' do
        if logged_in?
            stock = Stock.find(params[:id])
            stock.delete
            redirect to '/stocks'
        else
            redirect to '/login'
        end
    end
end