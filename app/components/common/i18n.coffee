# i18n values
data =
  ru:
    layouts:
      main:
        site_name: "StudyTime"
        about: "О проекте"
        terms: "Соглашение"
        authors: "Кто авторы?"
        navigation:
          schedule: "Расписание"
          places: "Аудитории"
          courses: "Спецкурсы"
          professors: "Преподы"

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
        updating: "Обновление..."
        updated: "Обновлено"
        groups: "Группы"
      studies:
        Mon: "Понедельник"
        Tue: "Вторник"
        Wed: "Среда"
        Thu: "Четверг"
        Fri: "Пятница"
        Sat: "Суббота"
      exams:
        exam: 'Экзамены'
        test: 'Зачеты'
        consult: 'консультация'

# Memorized localized value getter
getLocalizedValue = _.memoize((locale, path) ->
  pointsPath = path
  path = "[\"" + path.split(".").join("\"][\"") + "\"]"

  try
    res = eval("data." + locale + path)
    throw ("undefined")  if res is undefined
    res
  catch err
    'translation missing ' + pointsPath
, (params...) ->
  params.join(".")
)

# Rendering
{span} = React.DOM

module.exports = React.createClass
  getInitialState: ->
    locale: 'ru'

  render: ->
    path = if _.isArray(@props.children) then @props.children[0] else @props.children
    (span {}, getLocalizedValue(@state.locale, path))