class Track < ActiveRecord::Base
	belongs_to :user
	scope :unplayed,	-> { where(play_count: 0) }

	# Updates the track play count
	def is_being_played!
		 Track.update_counters(self, play_count: 1)
	end
	# Udates the track skip count	
	def is_being_skipped!
		 Track.update_counters(self, skip_count: 1)
	end
end