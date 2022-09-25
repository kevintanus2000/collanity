class Product < ApplicationRecord
    validates :name, presence: true
    validates :size, presence: true
    validates :categories, presence: true
    validates :ingredients, presence: true
    validates :code, presence: true
    validates :image, presence: true
end
