class DropPriceFromStocks < ActiveRecord::Migration
  def change
    remove_column :stocks, :price
  end
end
