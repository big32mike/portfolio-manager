class Portfolio < ActiveRecord::Base
    belongs_to :user
    belongs_to :category
    has_many :stocks, dependent: :destroy
    # https://guides.rubyonrails.org/association_basics.html#the-has-many-association
end
