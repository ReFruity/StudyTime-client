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

    templates:
      joinTo:
        'js/dontUseMe': /^app/ # dirty hack for Jade compiling.
#        'index.html': /^app\/index/

  plugins:
    jade:
      pretty: yes # Adds pretty-indentation whitespaces to output (false by default)
    jade_angular:
      single_file: true
      single_file_name: 'js/partials.js'
      static_mask: /^app,index.jade/ # static index.html
      locals: {}
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
