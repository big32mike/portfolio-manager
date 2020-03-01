class AddPriceAndQuantityToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :price, :float
    add_column :stocks, :quantity, :integer
  end
end
