{span, div, ul, li, nav, a, i, header} = React.DOM
{classSet} = React.addons
{userNavControl} = requireComponents('/user', 'userNavControl')
{i18n} = requireComponents('/common', 'i18n')

module.exports = React.createClass
  shouldComponentUpdate: (newProps)->
    newProps.path != @props.path

  render: ->
    (header {}, [
      (nav {className: "container", role: "navigation"}, [

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
                (i {className: "stico-schedule visible-xs"}, [])
                (i18n {}, 'layouts.main.navigation.schedule')
              ])
            ])
            (li {className: classSet("active": @props.path == "places")}, [
              (a {href: "/places"}, [
                (i {className: "stico-map visible-xs"}, [])
                (i18n {}, 'layouts.main.navigation.places')
              ])
            ])
            (li {className: classSet("active": @props.path == "courses")}, [
              (a {href: "/courses"}, [
                (i {className: "stico-spec-courses visible-xs"}, [])
                (i18n {}, 'layouts.main.navigation.courses')
              ])
            ])
            (li {className: classSet("active": @props.path == "professors")}, [
              (a {href: "/professors"}, [
                (i {className: "stico-spec-courses visible-xs"}, [])
                (i18n {}, 'layouts.main.navigation.professors')
              ])
            ])
            (li {}, [
              (userNavControl {}, [])
            ])
          ])
        ])
      ])
    ])