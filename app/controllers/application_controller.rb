class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  require 'dropbox_sdk'

  APP_KEY = 'x8k7o2xskm0kw7u'
  APP_SECRET = '7brk3tucfkkltvp'


	# Shows the home page
	def index
	end

end
