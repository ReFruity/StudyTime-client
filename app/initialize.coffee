# Init the app
require 'fetchThis'
require 'helpers'
require 'routes'
require 'html5links'

# Run history on the client
if typeof window != 'undefined'
	require('ready')(->
	  # Remove 300ms delay on touch devices
	  require('fastclick')(document.body)

	  # Initialize Backbone History
	  require('backbone').history.start pushState: yes
	)
