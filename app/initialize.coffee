# Load App Helpers
require 'lib/helpers'

# Initialize Router
require 'routers/main'

$ ->
  # Make all links html5
  $("body").on("click", "a", (e) ->
    e.preventDefault()
    href = $(this).attr("href")
    Backbone.history.navigate(href, true)
  )

  # Initialize Backbone History
  Backbone.history.start pushState: yes
