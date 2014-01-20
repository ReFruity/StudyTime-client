{span} = React.DOM

##
# Component for showing details about class in schedule
# Have two parts:
#   * Class detailed information
#   * Attachments to subject of the class
#
module.exports = React.createClass
  render: ->
    (span {}, 'details')