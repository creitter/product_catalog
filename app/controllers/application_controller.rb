class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # Hard coding the merchant id into the session here for demo purposes
  def load_merchant
    session[:merchant_id] = Merchant.first
    return session[:merchant_id]
  end
  
end
