require 'open-uri'
require 'json'

class ProductController < ApplicationController
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
    code = params[:code]
    uri = URI.parse("http://world.openfoodfacts.org/api/v0/product/"+ code +".json")
    str = JSON.parse(uri.read)
    logger.debug(str["code"])
    if str["code"] == ""
      flash[:error] = "Upc Code Is Not Valid"
      redirect_to('/product/add')
    else
      @data = Product.new(name: str["product"]["product_name"], size: str["product"]["quantity"], brands: str["product"]["brands"], categories: str["product"]["categories"], ingredients: str["product"]["ingredients_text"], code: code+".json", image: str["product"]["image_url"])
      if @data.save
        flash[:message] = "Product Data Successfully Added !!"
        redirect_to('/product/index')
      else
        flash[:error] = "Product Data Failed To Add !!"
        redirect_to('/product/add')
      end
    end
  end

  def delete
    @data = Product.find_by(id: params[:id])
    if @data.destroy
      flash[:message] = "Product Data Successfully Deleted !!"
      redirect_to('/product/index')
    else
      flash[:error] = "Product Data Failed To Delete !!"
      redirect_to('/product/index')
    end
  end

end
