class UsersController < ApplicationController
# check for user
def login_or_signup
	auth_url = get_web_auth.start()		
	redirect_to auth_url
end
# Callback from oath flow
def dropbox_callback
	access_token, user_id, url_state = get_web_auth.finish(params)
	@user = User.find_or_initialize_by(db_user_id: user_id)
	if @user.update_attributes(auth_token: access_token)
		redirect_to user_dash_path(@user)
	end
end
# users page
def dash
	@user = User.find(params[:user_id])
 	
 	update_tracks(@user)


end

private
	
	
	def update_tracks(@user)
		dir_to_search = Array.new
		client = DropboxClient.new(@user.auth_token)

		client.metadata("/Music").contents.each do |f|
 		if f.is_dir?
 			dir_to_search << f.path
 		elsif f.path.split(//).last(3).join == "mp3"
 			Track.new(file_name: f.path, user: @user)


	end

	def get_web_auth()
		return DropboxOAuth2Flow.new(APP_KEY, APP_SECRET, dropbox_callback_url, session, :dropbox_auth_csrf_token)
	end




end
