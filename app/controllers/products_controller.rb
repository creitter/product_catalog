require "csv"

class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :save_return_to, only: [:show, :edit, :update, :import]
    
  # GET /products
  # GET /products.json
  def index
    page = params[:page]
    page ||= 1

    @merchant = load_merchant
    @products = Product.paginate(page: page, per_page: 10).order('created_at DESC').where(merchant: @merchant)
    
    # We might have an out of sync pagination request. If so, just refresh from the start
    if @products.empty? && page != 1
      @products = Product.paginate(page: 1, per_page: 10).order('created_at DESC').where(merchant: @merchant)
    end
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
    @product.merchant = load_merchant

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
  
  def destroy_bulk
    product_ids = params[:ids]
    messages = []
    
    if product_ids.empty?
      messages << "Please select at least one product to delete."
    else
      # Get Products
      products_to_be_deleted = Product.where("id IN (?)", product_ids).to_a
      if products_to_be_deleted.empty? 
        messages << "These products have already been deleted."
      else  
        products_to_be_deleted.each{|product|
          if product.destroy 
            messages << "#{product.name} was deleted."
          else
            messages << "#{product.name} was not deleted. Error: #{product.errors}"
          end
        }
      end
    end
    
    # TODO: Handle case when some product ids were deleted and others were not because they were already removed.(front end error)
    
    if request.xhr?
      render json: { message: messages}
    end
  end

  def import
    
  end
  
  def process_import
    uploaded_file = params[:importing_products]
    
    if uploaded_file.present?
      # TODO: Determine if the file is too large. If it is, break it into pieces to make it more processable.
      # Use File.size?, File.seek (IO.seek) and loop through the file creating it based on the timestamp
      # Until this is done, we'll assume file size is not an issue for copying the file.
    
      # If the file size isn't an issue but the processing/importing is, we can handle that in the import products method
      filename = Rails.root.join('public', 'uploads', uploaded_file.original_filename + Time.now.getutc.to_i.to_s)
    
      begin
        File.open(filename, 'wb') do |file|
          file.write(uploaded_file.read)
        end

        @products = import_products(filename)
        
        # TODO: To avoid the repost issue, either write this to a batch file and read from the batch file based on the batch id or write it to another csv file. For now we just save it for this one time page rendering.
        
      rescue Exception => e
        @error_message = e.message
      end
    else
      @error_message = "Please select a file to upload"
    end
    
    respond_to do |format|
      format.html { render :import}
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
    
    def save_return_to
      # We don't have a return_to saved and the page was reloaded not redirected to
      if session[:return_to].nil? && request.referer.nil?
        session[:return_to] = products_path
      elsif !request.referer.nil? # We do not have a reload, but a valid back url.
        session[:return_to] = request.referer
        # else we use the previously saved return_to url.
      end
    end
 
    # Import the products from the filename
    # TODO: Add to external services file so we can access it via a CLI if needed.
    
    def import_products(filename)
      
      products = []
      merchant = load_merchant
      
      if File.exists?(filename)
        
        CSV.foreach(filename) do |row|
          name = row[0]
          description = row[1]
          value = row[2]
          height = row[3]
          weight = row[4]
          length = row[5]
          width = row[6]
          
          # TODO: If we had a product number, we could validate they don't already exist before adding them.          
          product = Product.create(name: name, description: description, value: value, height: height, width: width, length: length, weight: weight, merchant: merchant)
          products << {product: product, error: product.errors}
        end
      else
        products << {error: {messages: [{file: "#{filename} does not exist. There was a problem processing the file you uploaded."}]}}
      end
      
      products
      
    end
  end
