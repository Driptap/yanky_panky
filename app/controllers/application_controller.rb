class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  require 'dropbox_sdk'
  APP_KEY = 'x8k7o2xskm0kw7u'
  APP_SECRET = '7brk3tucfkkltvp'
	# Shows the home page
	def index
		if @user = User.find_by_id(session[:user]) 
			redirect_to user_dash_path(@user) 
		end
	end
end