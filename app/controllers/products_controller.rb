require "csv"

class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def upload
    uploaded_file = params[:importing_products]
    
    # TODO: Determine if the file is too large. If it is, break it into pieces to make it more processable.
    # Use File.size?, File.seek (IO.seek) and loop through the file creating it based on the timestamp
    # Until this is done, we'll assume file size is not an issue for copying the file.
    
    # If the file size isn't an issue but the processing/importing is, we can handle that in the import products method
    filename = Rails.root.join('public', 'uploads', uploaded_file.original_filename + Time.now.getutc.to_i.to_s)
      
    File.open(filename, 'wb') do |file|
      file.write(uploaded_file.read)
    end
    
    products = import_products(filename)
    invalid_products = products.select {|item| item if !item[:error].empty? }
    
    @products = Product.all

    respond_to do |format|
      if invalid_products.empty?
        format.html { redirect_to products_imported_url, notice: 'Products were uploaded.' }
        format.json { render :imported_products, status: :ok, location: @product }
      else
        format.html { render :imported_products }
        format.json { render json: @products, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :description, :width, :length, :height, :weight, :value)
    end
    
    # Import the products from the filename
    # TODO: Add to external services file?
    def import_products(filename)
      
      products = []
      
      if File.exists?(filename)
        
        CSV.foreach(filename) do |row|
          name = row[0]
          description = row[1]
          value = row[2]
          height = row[3]
          weight = row[4]
          length = row[5]
          width = row[6]

          product = Product.create(name: name, description: description, value: value, height: height, width: width, length: length, weight: weight)

          # Validate they don't already exist before adding them.
          products << {product: product, error: product.errors}
        end
      else
        products << {error: "There was a problem processing the file you uploaded."}
      end
      
      products
  
    end
  end
