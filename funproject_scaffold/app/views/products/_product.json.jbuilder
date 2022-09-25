json.extract! product, :id, :name, :size, :brands, :categories, :ingredients, :code, :image, :created_at, :updated_at
json.url product_url(product, format: :json)