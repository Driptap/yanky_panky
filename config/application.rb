require File.expand_path('../boot', __FILE__)
require 'rails/all'
Bundler.require(*Rails.groups)
module YankyPanky
  class Application < Rails::Application
  	# Sets dropbox api keys using env vars
		DROPBOX_APP_KEY = ENV["DROPBOX_APP_KEY"]
		DROPBOX_APP_SECRET = ENV["DROPBOX_APP_SECRET"]
		# Dropbox key fallbacks for dev env
		if Rails.env.development? 
			DROPBOX_APP_KEY ||= 'x8k7o2xskm0kw7u'
			DROPBOX_APP_SECRET ||= '7brk3tucfkkltvp'
		end
		# Raises errors if keys aren't set in env 
		raise "You need to set the Dropbox app key in ENV['DROPBOX_APP_KEY']" if DROPBOX_APP_KEY.blank?
		raise "You need to set the Dropbox app secret in ENV['DROPBOX_APP_SECRET']" if DROPBOX_APP_SECRET.blank?
  end
end
