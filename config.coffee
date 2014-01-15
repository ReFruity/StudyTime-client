exports.config =
# See docs at http://brunch.readthedocs.org/en/latest/config.html.
  conventions:
    assets: /^app\/(assets|font)\//

  modules:
    definition: no
    wrapper: no

  paths:
    public: '_public'

  files:
    javascripts:
      joinTo:
        'js/app.js': /^app/
        'js/vendor.js': /^(bower_components|vendor)/
      order:
        before: [
          'app/app.coffee'
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
      pretty: yes # Adds pretty-indentation whitespaces to output (false by default)
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

# Enable or disable minifying of result js / css files.
  minify: yes
