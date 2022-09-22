require 'open-uri'
require 'json'

class ProductController < ApplicationController

  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing

  def index
    @data = Product.select(:name,:id)
  end

  def add
  end
  
  def detail
    @data = Product.find_by(id: params[:id])
    if !@data
      redirect_to('/product/index')
    end
  end

  def create
    if internet_connection("http://world.openfoodfacts.org")
      code = product_params
      if code !~ /\D/
        uri = URI.parse("http://world.openfoodfacts.org/api/v0/product/"+ code +".json")
        str = JSON.parse(uri.read)
        if str["status"] == 1
          data = Product.new(name: str["product"]["product_name"], size: str["product"]["quantity"], brands: str["product"]["brands"], categories: str["product"]["categories"], ingredients: str["product"]["ingredients_text"], code: code+".json", image: str["product"]["image_url"])
          if data.save
            flash[:message] = "Product Data Successfully Added !!"
            redirect_to('/product/index')
          else
            flash[:error] = "Product Data Failed To Add !!"
            redirect_to('/product/add')
          end
        else
          flash[:error] = "Upc Code Is Not Valid"
          redirect_to('/product/add')
        end
      else
        flash[:error] = "Upc Code Must Be Positive Numbers"
        redirect_to('/product/add')
      end
    else
      flash[:error] = "There Is No Internet Connection"
      redirect_to('/product/add')
    end
  end

  def delete
    data = Product.find_by(id: params[:id])
    if data.destroy
      flash[:message] = "Product Data Successfully Deleted !!"
      redirect_to('/product/index')
    else
      flash[:error] = "Product Data Failed To Delete !!"
      redirect_to('/product/index')
    end
  end

  def internet_connection(url)
    begin
      true if URI.open(url)
    rescue
      false
    end
  end

  def handle_parameter_missing(exception)
    flash[:error] = "Upc Code Must Be Filled"
    redirect_to('/product/add')
  end

  private
    def product_params
      params.require(:code)
    end

end
