module DropboxSessions
  extend ActiveSupport::Concern
  included do
    helper_method :dropbox_sessions
  end
  # Signs in the user
  def start_session(user)
    session[:user] = User.find(user).id
  end
  # Returns the current user
  def current_user
    User.find(session[:user])
  end
  # Ends the session
  def end_session(user)
    return true if session[:user] = nil && session[:now_playing] = nil
  end
  # Checks if connected to dropbox as a client
  def connected_to_dropbox_as_client?
    connect_client if $client.blank?
  end
  # Connects as a dropbox client
  def connect_client
    if user = User.find_by_id(session[:user])
      $client = DropboxClient.new(user.auth_token)
    end
  end
  # Sets up Dropbox oauth2 flow object
  def get_web_auth
    return DropboxOAuth2Flow.new('x8k7o2xskm0kw7u', '7brk3tucfkkltvp', dropbox_callback_url, session, :dropbox_auth_csrf_token)
  end
end