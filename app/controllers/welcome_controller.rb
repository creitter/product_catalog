class WelcomeController < ApplicationController

  def index
    @merchant = Merchant.find_by_id(load_merchant)
  end
  
end
