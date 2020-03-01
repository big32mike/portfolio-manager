class Stock < ActiveRecord::Base
    validates_presence_of :symbol, :name
    belongs_to :portfolio
end