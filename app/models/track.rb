class Track < ActiveRecord::Base
	belongs_to :user

	def is_being_played!
		 Track.update_counters(self, play_count: 1)
	end
	def is_being_skipped!
		 Track.update_counters(self, skip_count: 1)
	end
end
