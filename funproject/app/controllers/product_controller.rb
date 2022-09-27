require 'open-uri'
require 'json'

class ProductController < ApplicationController

  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  before_action :set_product, only: %i[ create ]
  before_action :detail_delete_product, only: %i[ detail delete ]

  def index
    @data = Product.select(:name,:id)
  end

  def add
  end
  
  def detail
  end

  def create
    if internet_connection("http://www.google.com")
      code = code_params
      if code !~ /\D/
        uri = URI.parse("http://world.openfoodfacts.org/api/v0/product/"+ code +".json")
        str = JSON.parse(uri.read)
        if str["status"] == 1
          params = ActionController::Parameters.new(product: { name: str["product"]["product_name"], size: str["product"]["quantity"], brands: str["product"]["brands"], categories: str["product"]["categories"], ingredients: str["product"]["ingredients_text"], code: code + ".json", image: str["product"]["image_url"] })
          data = Product.new(product_params(params))
          if data.save
            flash[:message] = "Product Data Successfully Added !!"
            redirect_to('/product/index')
          else
            flash[:error] = "Product Data Failed To Add, Product " + data.errors.full_messages[0] + " In Json File"
            redirect_to('/')
          end
        else
          flash[:error] = "Upc Code Is Not Valid"
          redirect_to('/')
        end
      else
        flash[:error] = "Upc Code Must Be Positive Numbers"
        redirect_to('/')
      end
    else
      flash[:error] = "There Is No Internet Connection"
      redirect_to('/')
    end
  end

  def delete
    if @data.destroy
      flash[:message] = "Product Data Successfully Deleted !!"
      redirect_to('/product/index')
    else
      flash[:error] = "Product Data Failed To Delete !!"
      redirect_to('/product/index')
    end
  end

  private

    def internet_connection(url)
      begin
        true if URI.open(url)
      rescue
        false
      end
    end

    def handle_parameter_missing(exception)
      flash[:error] = "Upc Code Must Be Filled"
      redirect_to('/')
    end
    
    def set_product
      @data = Product.find_by_code(code_params + ".json")
      if @data
        flash[:error] = "Product Data With This Upc Code Is Exists"
        redirect_to('/')
      end
    end

    def detail_delete_product
      @data = Product.find_by_id(id_params)
      if !@data
        flash[:error] = "Product Not Found !!"
        redirect_to('/product/index')
      end
    end

    def code_params
      params.require(:code)
    end

    def id_params
      params.require(:id)
    end

    def product_params(params)
      params.require(:product).permit(:name, :size, :brands, :categories, :ingredients, :code, :image)
    end

end
