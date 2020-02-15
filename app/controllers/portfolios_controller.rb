class PortfoliosController < ApplicationController

    get '/portfolios' do
        erb :'portfolios/index'
    end
end