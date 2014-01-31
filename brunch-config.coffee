fs = require('fs');
sysPath = require('path');

exports.config =
  conventions:
    assets: /(assets|vendor\/assets|font)/

  modules:
    wrapper: (fullPath, data, isVendor) ->
      switch isVendor
        when true
          prefix: ";try {\n"
          suffix: "}catch(e){};\n\n"
        else
          sourceURLPath = fullPath.replace(new RegExp('\\\\', 'g'), '/').replace(/^app\//, '')
          moduleName = sourceURLPath.replace(/\.\w+$/, '')
          if moduleName == 'starter'
            data
          else
            path = JSON.stringify(moduleName)
            prefix: "req.define(#{path}, function(exports, require, module) {\n"
            suffix: "});\n\n"

    definition: ->
      fs.readFileSync(sysPath.join(__dirname, 'require.js'), 'utf8');

  paths:
    public: '_public'

  files:
    javascripts:
      joinTo:
        'js/app.js': /^app/

      pluginHelpers: 'js/app.js'
      order:
        before: [
          'vendor/zepto.min.js'
          'bower_components/lodash/dist/lodash.js'
          'bower_components/backbone/backbone.js'
          'vendor/backbone.fetchthis.js'
          'vendor/burry.js'
        ]
        after: [
          'app/starter.coffee'
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
