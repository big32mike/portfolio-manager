class AddCategoryIdToPortfolio < ActiveRecord::Migration
  def change
    add_column :portfolios, :category_id, :integer
  end
end
