exports.config =
# See docs at http://brunch.readthedocs.org/en/latest/config.html.
  conventions:
    assets: /^app\/(assets|font)\//

  modules:
    definition: false
    wrapper: false

  paths:
    public: '_public'

  files:
    javascripts:
      joinTo:
        'js/app.js': /^app/
        'js/vendor.js': /^(bower_components|vendor)/

    stylesheets:
      joinTo:
        'css/app.css': /^(app|vendor)/
        'css/font-awesome.css': /bower_components\/font-awesome\/css\/font-awesome\.css/

    templates:
      joinTo:
        'js/dontUseMe' : /^app/ # dirty hack for Jade compiling.
        'index.html' : /^app\/index/

  plugins:
    jade_angular:
      modules_folder: 'partials'
    uglify:
      mangle: true
      compress:
        global_defs:
          DEBUG: false

# Enable or disable minifying of result js / css files.
  minify: false
