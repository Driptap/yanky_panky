class User < ActiveRecord::Base
	has_many :tracks
	#validates_presence_of :db_user_id, :auth_token
	#validates_uniqueness_of :db_user_id
 	# Returns a predicted new track
	def find_track
		if self.tracks.length >= 1	
			if self.tracks.unplayed.length > 1
		    return self.tracks.unplayed.shuffle.first
		  else 
		    return tracks = self.tracks.sort_by {|x| [x.play_count, -x.skip_count] }.first
		  end
	  end
	end
end
