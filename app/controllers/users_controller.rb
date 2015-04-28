class UsersController < ApplicationController

# check for user
def login_or_signup
	auth_url = get_web_auth.start()		
	redirect_to auth_url
end
# Callback from oath flow
def dropbox_callback
	access_token, user_id, url_state = get_web_auth.finish(params)
	@user = User.find(session[:user_id])
	@user.auth_token = access_token
	
	if @user.save!
		redirect_to user_dash_path(@user)
	end
end
# users page
def dash
 @user = User.find(session[:user_id])

 client = DropboxClient.new(@user.auth_token)
 @tracks = client.metadata("Music", list: true) 

end
private

def get_web_auth()
	return DropboxOAuth2Flow.new(APP_KEY, APP_SECRET, dropbox_callback_url, session, :dropbox_auth_csrf_token)
end


end
