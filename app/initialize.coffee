# Load App Helpers
require 'lib/helpers'

# Initialize Router
require 'router'

$ ->
  # Remove 300ms delay on touch devices
  FastClick.attach(document.body);

  # Define React renderer function
  contentElem = $('#content')[0]
  React.appRenderer = (app) ->
    React.renderComponent app, contentElem

  # Initialize Backbone History
  Backbone.history.start pushState: yes
