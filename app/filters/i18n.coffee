angular.module('app.filters').filter('translate', [ ->
  data =
    ru:
      layouts:
        main:
          site_name: "StudyTime"
          about: "О проекте"
          terms: "Соглашение"
          authors: "Кто авторы?"
          navigation:
            shedule: "Расписание"
            auditoriums: "Аудитории"
            cources: "Спецкурсы"

      buttons:
        sign_in: "Вход"

      schedules:
        index:
          choose_group: "Выберите группу"
          subscribe: "Подписаться"
          next_week: "Следующая неделя"
        studies:
          Mon: "Понедельник"
          Tue: "Вторник"
          Wed: "Среда"
          Thu: "Четверг"
          Fri: "Пятница"
          Sat: "Суббота"

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
