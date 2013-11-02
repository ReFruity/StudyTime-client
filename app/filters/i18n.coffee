angular.module('app.filters').filter('translate', [ ->
  data =
    ru:
      layouts:
        main:
          about: "О проекте"
          terms: "Соглашение"
          authors: "Кто авторы?"

      schedules:
        index:
          choose_group: "Выберите группу"


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
