##
# Provides functionality for canceling events
# On submit it cancels selected in schedule event
#
module.exports = React.createClass
  propTypes:
    date: React.PropTypes.object
    event: React.PropTypes.object

  getInitialState: ->
    event: {}

  render: ->
    (div {className: 'ccl-event'}, [
      (if not @props.date
        (div {},
          (i18n {}, 'schedule.editor.select_cancel_cell')
        )
      else
        (div {}, 'ok')
      )
    ])