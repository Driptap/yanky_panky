class RegisterUser
	def self.call(auth_callback)
		access_token, user_id, url_state = auth_callback
		if user = User.find_or_initialize_by(db_user_id: user_id)
			user.update!(auth_token: access_token)	
			return user
		end
	end
end