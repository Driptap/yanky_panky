class UsersController < ApplicationController
  before_action :connected_to_dropbox_as_client?, except: %i[login_or_signup dropbox_callback ]
  # starts auth flow
  def login_or_signup
    auth_url = get_web_auth.start()		
  	redirect_to auth_url
  end
  # Callback from auth flow
  def dropbox_callback
    start_session(RegisterUser.call(get_web_auth.finish(params)))
    connect_client
		redirect_to user_dash_path(current_user)
  end
  # loads dash view
  def dash
   	check_for_new_tracks(current_user, $client)
  end
  # logs the user out
  def logout
    end_session(current_user)
    redirect_to root_path 
  end 
  # returns a new track
  def new_track
    track = current_user.find_track  
    track.is_being_played!
    session[:now_playing] = track.id
    render plain: $client.media(track.file_name)["url"]
  end
  # skips track and returns new track
  def skip_track
  	Track.find(session[:now_playing]).is_being_skipped!
  	new_track
  end
  # stores id3 data returned from front end
  def store_track_info
    if track = Track.find_by_id(session[:now_playing]).update_attributes(title: params[:track_title], artist: params[:track_artist], album: params[:track_album])
      render plain: "track info stored"
    else
      render plain: "track info not stored"
    end
  end
end