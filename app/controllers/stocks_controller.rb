class StocksController < ApplicationController
    
    get '/stocks' do
        @stocks = Stock.all
        erb :'stocks/index'
    end

    post '/stocks' do
        if params[:stock][:symbol] != "" && params[:stock][:name] != "" && params[:stock][:asset_class] != ""
            stocks << Stock.create(params[:stock])
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
end