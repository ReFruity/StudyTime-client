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
        no_schedule_with_stuff: "Расписания пока нет"
        no_schedule_without_stuff: "Расписания пока нет, мало того, его некому добавить, ведь в группе нет старосты :("
        index:
          choose_group: "Выберите группу"
          subscribe: "Подписаться"
          next_week: "Следующая неделя"
        navigation:
          session: "Сессия"
          semestr: "Семестр"
          updating: "Загрузка..."
          updated: "Обновлено"
          groups: "Группы"
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
