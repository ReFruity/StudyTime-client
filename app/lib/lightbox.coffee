React = require 'react'
Gator = require 'gator'
_ = require 'underscore'

# Stack for showed lightboxes
lbStack = []
lightboxCont = document.getElementById('lightbox')
lbElement = lightboxCont.children[1].children[0].children[1]
bodyElem = document.body

# Add handler of closing lightbox by click
# on the glow
Gator(lightboxCont.children[1].children[0].children[0]).on 'click', ->
  closeLastLightbox()

# Close on escape
Gator(bodyElem).on 'keydown', (e)->
  if e.keyCode == 27
    closeLastLightbox()

# Close last opened lightbox
closeLastLightbox = ->
  if lbStack.length
    lastCom = lbStack.pop()
    lastCom.onClose()

# Handler for closing lightbox
onCloseLightbox = ->
  lbStack.pop()
  if not lbStack.length
    bodyElem.className = ''
  else
    renderLightboxComponent(lbStack[lbStack.length-1])

# Render lightbox and centring it
renderLightboxComponent = (compInstance)->
  # Render component to lightbox element
  React.renderComponent compInstance, lbElement

  # Centrize wrap element
  setTimeout(->
    width = lbElement.offsetWidth
    height = lbElement.offsetHeight
    lbElement.style.marginLeft = "-#{width/2}px"
    lbElement.style.marginTop = "-#{height/2}px"
  , 0)

##
# Module for showing lightboxes
# It support showing "lightbox in lightbox" with stack
#
module.exports = (component, props={}) ->
  # Disable lightboxes on Node.js
  return if typeof window == 'undefined'

  # Create component element
  compInstance = component(_.assign({onClose: onCloseLightbox}, props))
  lbStack.push compInstance
  bodyElem.className = 'lightbox-showed'
  renderLightboxComponent(compInstance)
