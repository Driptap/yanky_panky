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
 	@track = get_track(@user)
 	session[:user] = @user.id
end
def new_track
	@user = User.find(session[:user]) 
  render plain: get_track(@user)["url"] 
end

def skip_track
	@user = User.find(session[:user])
	track = Track.find(session{:track})
	# needs to be default value
	track.skip_count = ( track.skip_count || 0 ) + 1 
	track.save
	new_track
end
private
	
	def get_track(user)
 		client = DropboxClient.new(user.auth_token)
 		track = user.tracks.order("RANDOM()").first
		session[:now_playing] = track.id
		t = Track.find(session[:now_playing])
		#This is bodged, needs to be a default value
		t.play_count = (t.play_count || 0) + 1
		t.save
		return client.media(track.file_name)
	end

	def update_tracks(user)
		client = DropboxClient.new(user.auth_token)
		db_tracks = client.metadata("/Music/Blues")["contents"]
		if db_tracks.length != @user.tracks.all.length
			db_tracks.each do |f|
				if f["path"].split(//).last(3).join == "mp3"
					Track.create(file_name: f["path"], user: user)
				end
		 	end
		end
	end

	def get_web_auth()
		return DropboxOAuth2Flow.new(APP_KEY, APP_SECRET, dropbox_callback_url, session, :dropbox_auth_csrf_token)
	end
end