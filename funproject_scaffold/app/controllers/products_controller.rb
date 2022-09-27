require 'open-uri'
require 'json'

class ProductsController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  before_action :set_product, only: %i[ create ]
  before_action :detail_destroy_product, only: %i[ show destroy ]
  before_action :set_empty_product, only: %i[ new ]


  # GET /products or /products.json
  def index
    @products = Product.all
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
  end

  # POST /products or /products.json
  def create
    if internet_connection("http://www.google.com")
      code = code_params
      if code !~ /\D/
        uri = URI.parse("http://world.openfoodfacts.org/api/v0/product/"+ code +".json")
        str = JSON.parse(uri.read)
        if str["status"] == 1
          params = ActionController::Parameters.new(product: { name: str["product"]["product_name"], size: str["product"]["quantity"], brands: str["product"]["brands"], categories: str["product"]["categories"], ingredients: str["product"]["ingredients_text"], code: code + ".json", image: str["product"]["image_url"] })
          product = Product.new(product_params(params))
          respond_to do |format|
            if product.save
              format.html { redirect_to products_url, notice: "Product Data Successfully Added !!" }
              format.json { render :show, status: :created, location: product }
            else
              set_empty_product
              format.html { 
                flash.now[:error] = "Product Data Failed To Add, Product " + product.errors.full_messages[0] + " In Json File" 
                render :new, status: :unprocessable_entity
              }
              format.json { render json: product.errors, status: :unprocessable_entity }
            end
          end
        else
          set_empty_product
          respond_to do |format|
            format.html {
              flash.now[:error] = 'Upc Code Is Not Valid'
              render :new, status: :unprocessable_entity
            }
            format.json { 
              head :no_content 
            }
          end
        end
      else
        set_empty_product
        respond_to do |format|
          format.html {
            flash.now[:error] = 'Upc Code Must Be Positive Numbers'
            render :new, status: :unprocessable_entity
          }
          format.json { 
            head :no_content 
          }
        end
      end
    else
      set_empty_product
      respond_to do |format|
        format.html {
          flash.now[:error] = 'There Is No Internet Connection'
          render :new, status: :unprocessable_entity
        }
        format.json { 
          head :no_content 
        }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    respond_to do |format|
      if @product.destroy
        format.html { redirect_to products_url, notice: "Product Data Successfully Deleted !!" }
        format.json { head :no_content }
      else
        format.html {
          flash[:error] = 'Product Data Failed To Delete !!'
          redirect_to products_url
        }
        format.json { head :no_content }
      end
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
      set_empty_product
      respond_to do |format|
        format.html {
          flash.now[:error] = 'Upc Code Must Be Filled'
          render :new, status: :unprocessable_entity
        }
        format.json { 
          head :no_content 
        }
      end
    end
    
    def set_product
      product = Product.find_by_code(code_params + ".json")
      if product
        set_empty_product
        respond_to do |format|
            format.html {
              flash.now[:error] = 'Product Data With This Upc Code Is Exists'
              render :new, status: :unprocessable_entity
            }
            format.json { 
              head :no_content 
            }
        end
      end
    end

    def set_empty_product
      @product = Product.new
    end

    def product_params(params)
      params.require(:product).permit(:name, :size, :brands, :categories, :ingredients, :code, :image)
    end

    def detail_destroy_product
      @product = Product.find_by_id(id_params)
      if !@product
        respond_to do |format|
            format.html { 
              flash[:error] = "Product Not Found !!"
              redirect_to products_url
             }
            format.json { head :no_content }
        end
      end
    end

    def code_params
      params.require(:product)
      params[:product].require(:code)
    end

    def id_params
      params.require(:id)
    end
end
