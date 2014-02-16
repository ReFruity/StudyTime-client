# Init the app
require 'fetchCache' if typeof window != 'undefined'
require 'fetchThis'
require 'helpers'
require 'routes'
require 'html5links'
require 'jquery'

# Run history on the client
if typeof window != 'undefined'
	require('ready')(->
	  # Remove 300ms delay on touch devices
	  require('fastclick')(document.body)

	  # Initialize Backbone History
	  require('backbone').history.start pushState: yes
	)
