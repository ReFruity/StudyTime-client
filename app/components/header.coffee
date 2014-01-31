React = require 'react'
{span, div, ul, li, nav, a, i, header} = React.DOM
{classSet} = React.addons
{userNavControl} = require '/components/user', 'userNavControl'
{i18n} = require '/components/common', 'i18n'

module.exports = React.createClass
  shouldComponentUpdate: (newProps)->
    newProps.path != @props.path

  render: ->
    (header {}, [
      (nav {className: "container", role: "navigation"}, [
        (div {className: 'row'}, [
          # Brand
          (div {className: "brand"}, [
            (a {href: "#"}, [
              (i {className: "stico-logo"}, [])
              (i18n {}, 'layouts.main.site_name')
            ])
          ])

          # Navigation buttons
          (div {className: "navbar"}, [
            (ul {}, [
              (li {className: classSet("active": @props.path in ["groups", "schedule"])}, [
                (a {href: "/"}, [
                  (div {}, (i {className: "stico-schedule"}, []))
                  (i18n {}, 'layouts.main.navigation.schedule')
                ])
              ])
              (li {className: classSet("active": @props.path == "places")}, [
                (a {href: "/places"}, [
                  (div {}, (i {className: "stico-map"}, []))
                  (i18n {}, 'layouts.main.navigation.places')
                ])
              ])
              (li {className: classSet("active": @props.path == "courses", 'courses':yes)}, [
                (a {href: "/courses"}, [
                  (div {}, (i {className: "stico-spec-courses"}, []))
                  (i18n {}, 'layouts.main.navigation.courses')
                ])
              ])
              (li {className: classSet("active": @props.path == "professors")}, [
                (a {href: "/professors"}, [
                  (div {}, (i {className: "stico-spec-courses"}, []))
                  (i18n {}, 'layouts.main.navigation.professors')
                ])
              ])
              (li {className: 'login-wrap'}, [
                (userNavControl {}, [])
              ])
            ])
          ])
        ])
      ])
    ])