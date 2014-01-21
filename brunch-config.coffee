exports.config =
  conventions:
    assets: /(assets|vendor\/assets|font)/

  paths:
    public: '_public'

  files:
    javascripts:
      joinTo:
        'js/app.js': /^app/
        'js/vendor.js': /^(bower_components|vendor)/

      pluginHelpers: 'js/app.js'
      order:
        before: [
          'vendor/zepto.min.js'
          'bower_components/lodash/dist/lodash.js'
          'bower_components/backbone/backbone.js'
          'vendor/backbone.fetchthis.js'
          'vendor/backbone.route.js'
          'vendor/burry.js'
        ]

    stylesheets:
      joinTo:
        'css/app.css': /^(app|vendor)/
      order:
        before: [
          'app/styles/app.styl'
        ]

  plugins:
    uglify:
      mangle: yes
      compress:
        global_defs:
          DEBUG: yes

    stylus:
      includeCss: yes

    cleancss:
      keepSpecialComments: 0
      removeEmpty: true

    autoReload:
      enabled:
        js: on
        css: on
        assets: off
