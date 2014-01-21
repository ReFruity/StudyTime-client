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
        ]

    stylesheets:
      joinTo:
        'css/app.css': /^(app|vendor)/
      order:
        before: [
          'app/styles/app.styl'
        ]

    templates:
      joinTo:
        'js/dontUseMe': /^app/

  plugins:
    jade:
      pretty: no

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
