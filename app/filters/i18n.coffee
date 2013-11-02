angular.module('app.filters').filter('translate', [ ->
  data =
    ru:
      partials:
        terms:
          title: "Заголовок"

  (path) ->
    @locale = 'ru'
    pointsPath = path
    path = "[\"" + path.split(".").join("\"][\"") + "\"]"
    try
      res = eval("data." + @locale + path)
      throw ("undefined")  if res is undefined
      res
    catch err
      'translation missing ' + pointsPath
])
