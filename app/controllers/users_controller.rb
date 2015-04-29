class UsersController < ApplicationController
 before_action :connected_to_dropbox_as_client?
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
		session[:user] = @user.id
    connect_client
		redirect_to user_dash_path(@user)
	end
end
# dash view
def dash
	@user = User.find(params[:user_id])
 	check_for_new_tracks(@user)
 	@track = get_track(@user)
end
# returns a new track
def new_track
	@user = User.find(session[:user]) 
  render plain: get_track(@user)["url"] 
end
# skips track and returns new track
def skip_track
	@user = User.find(session[:user])
	Track.find(session[:now_playing]).is_being_skipped!
	new_track
end

private
  def connected_to_dropbox_as_client?
    connect_client if $client.blank?
  end
	# Connects as a dropbox client
	def connect_client
    user = User.find(session[:user])
		$client = DropboxClient.new(user.auth_token)
	end
  # Returns a single track for a user
	def get_track(user)
   	if user.tracks.length >= 1	
      if user.tracks.unplayed.length > 1
        tracks = user.tracks.unplayed
      else 
        tracks = user.tracks.sort_by {|x| [x.play_count, -x.skip_count] }
      end
      track = tracks.first
  		session[:now_playing] = track.id
  		Track.find(session[:now_playing]).is_being_played!
  		return $client.media(track.file_name)["url"]
    end
	end
  # Checks for changes in the users music directory
	def check_for_new_tracks(user)
  	if user.track_rev != $client.metadata("/Music")["rev"] 	
	 	  user.update_attributes(track_rev: $client.metadata("/Music")["rev"]) if scan_dir_for_tracks("/Music", user)
    end
  end
  # Recursively scans directories starting with the route directory above. Validations shoould be moved to model
  def scan_dir_for_tracks(path, user)
    $client.metadata(path)["contents"].each do |f|
      if f["is_dir"] == true 
        scan_dir_for_tracks(f["path"], user) 
      elsif f["is_dir"] == false  
        if f["path"] != nil
          if f["path"].split(//).last(3).join == "mp3"
            Track.create(file_name: f["path"], user: user) unless Track.find_by(file_name: f["path"], user: user) 
          end
        end
      end
    end
    return true
  end
  # Sets up Dropbox oauth2 flow object
	def get_web_auth
		return DropboxOAuth2Flow.new(APP_KEY, APP_SECRET, dropbox_callback_url, session, :dropbox_auth_csrf_token)
	end
end