# Load App Helpers
require 'lib/helpers'

# Initialize Router
require 'router'

$ ->
  # Remove 300ms delay on touch devices
  FastClick.attach(document.body);

  # Initialize Backbone History
  Backbone.history.start pushState: yes
