{span, div, ul, li, a, i, nav} = React.DOM
{classInfo, classAttachments} = requireComponents('/schedule/parts', 'classInfo', 'classAttachments')
{classSet} = React.addons
router = require 'router'

##
# Component for showing details about class in schedule.
# For reusing it in different places, exports a function with
# two arguments: `baseUrl` and `closeUrl` for right routing.
#
# Component consists of two parts:
#   * Class detailed information
#   * Attachments to subject of the class
#
module.exports = (baseUrl, closeUrl) ->
  React.createClass
    propTypes:
      data: React.PropTypes.object.isRequired

    getDefaultProps: ->
      params = router.getParams()
      detailsView: params.detailsView or 'info'

    render: ->
      (div {className: 'container class-details'}, [
        # Navigation
        (nav {className: 'details-nav'}, [
          (ul {}, [
            (li {className: classSet('current': @props.detailsView == 'info')}, [
              (a {href: "#{baseUrl}/info"}, [
                (i {className: 'stico-info'})
                (span {}, ['Информация'])
              ])
            ])
            (li {className: classSet('current': @props.detailsView == 'attachments')}, [
              (a {href: "#{baseUrl}/attachments"}, [
                (i {className: 'stico-files'})
                (span {}, ['Приложения'])
              ])
            ])
          ])
        ])

        # View container
        (div {className: 'details-view'}, (
          switch  @props.detailsView
            when 'info' then @transferPropsTo(classInfo {})
            when 'attachments' then @transferPropsTo(classAttachments {})
            else @transferPropsTo(classInfo {})
        ))

        # Closing cross
        (div {className: 'details-close'}, [
          (a {href: "#{closeUrl}"}, [
            (i {className: 'stico-cross'})
            (span {}, ['Закрыть'])
          ])
        ])
      ])