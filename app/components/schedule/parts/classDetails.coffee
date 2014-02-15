React = require 'react'
{span, div, ul, li, a, i, nav} = React.DOM
{clickOutside, i18n} = require '/components/common', 'clickOutside', 'i18n'
{classInfo, classAttachments} = require '/components/schedule/parts', 'classInfo', 'classAttachments', 'nav'
appNav = require '/components/schedule/parts/nav'
{classSet} = React.addons
router = require 'routes'

##
# Component for showing details about class in schedule.
# For reusing it in different places, exports a function with
# two arguments: `baseUrl` and `closeUrl` for right routing.
#
# Component consists of two parts:
#   * Class detailed information
#   * Attachments to subject of the class
#
module.exports = React.createClass
    mixins: [clickOutside]

    propTypes:
      data: React.PropTypes.object.isRequired
      dow: React.PropTypes.string.isRequired
      number: React.PropTypes.string.isRequired
      date: React.PropTypes.object.isRequired
      cellUrl: React.PropTypes.string.isRequired
      baseUrl: React.PropTypes.string.isRequired
      route: React.PropTypes.object.isRequired

    excludeClickOutside: '.exclude-co'
    onClickOutside: ->
      router.navigate(@props.baseUrl, {trigger: true})

    render: ->
      detailsView = @props.route.detailsView or 'info'

      div {className: 'container class-details'}, [
        # Navigation
        nav {className: 'details-nav'}, [
          ul {}, [
            li {className: classSet('current': detailsView == 'info')}, [
              a {href: "#{@props.cellUrl}/info"}, [
                i {className: 'stico-info'}
                i18n {}, 'schedule.details.info'
              ]
            ]
            li {className: classSet('current': detailsView == 'attachments')}, [
              a {href: "#{@props.cellUrl}/attachments"}, [
                i {className: 'stico-files'}
                i18n {}, 'schedule.details.attachments'
              ]
            ]
          ]
        ]

        # View container
        div {className: 'details-view'}, (
          switch  detailsView
            when 'info' then @transferPropsTo(classInfo {})
            when 'attachments' then @transferPropsTo(classAttachments {})
            else @transferPropsTo(classInfo {})
        )

        # Editor button
        if yes == yes
          appNav.EditorSwitcher {
            editor: @props.editor
            switchEditorHandler: @props.switchEditorHandler
            data: @props.data
            date: @props.date
            dow: @props.dow
            number: @props.number
          }

        # Closing cross
        div {className: 'details-close'}, [
          a {href: "#{@props.baseUrl}"}, [
            i {className: 'stico-cross'}
            i18n {}, 'schedule.details.close'
          ]
        ]
      ]