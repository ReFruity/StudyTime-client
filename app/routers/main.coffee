class MainRouter extends Backbone.Router
  controllers: {}
  routes:
    ":group(/:dow/:clazz/:atom)": "group"

  group: (group, dow, clazz, atom)->
    React.renderComponent (require('components/top') {
      group: group
      dow: dow
      clazz: clazz
      atom: atom
    }, []), document.body

main = new MainRouter()
module.exports = main
