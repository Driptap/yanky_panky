module TrackList
  extend ActiveSupport::Concern

  included do
    helper_method :tracks
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
  # Checks for changes in the users music directory using folder rev number
  def check_for_new_tracks(user, client)
    if user.track_rev != client.metadata("/Music")["rev"]  
      user.update_attributes(track_rev: client.metadata("/Music")["rev"]) if scan_dir_for_tracks("/Music", user)
    end
  end
end