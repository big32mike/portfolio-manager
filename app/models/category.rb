class Category < ActiveRecord::Base
    has_many :portfolios
end