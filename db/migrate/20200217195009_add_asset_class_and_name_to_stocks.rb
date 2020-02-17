class AddAssetClassAndNameToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :asset_class, :string
    add_column :stocks, :name, :string
  end
end
