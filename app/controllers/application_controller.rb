class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include TrackList
  include DropboxSessions
  require 'dropbox_sdk'
	# Shows the home page
	def index
		if @user = User.find_by_id(session[:user]) 
			redirect_to user_dash_path(@user) 
		end
	end
end