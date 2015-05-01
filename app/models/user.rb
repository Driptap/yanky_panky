class User < ActiveRecord::Base
	has_many :tracks
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
