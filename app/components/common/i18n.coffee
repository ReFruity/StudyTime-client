# i18n values
data =
  ru:
    date:
      day:
        ["Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота"]
      short_day:
        ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"]
      month:
        ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октабря', 'ноября',
         'декабря']
      short_month:
        ['янв.', 'фев.', 'мар.', 'апр.', 'мая', 'июн.', 'июл.', 'авг.', 'сент.', 'окт.', 'ноя.', 'дек.']

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

    attachments:
      header: 'Приложения'
      add: 'Добавить'
      file: 'Файл'
      link: 'Ссылка'
      types:
        note: 'Конспект'
        book: 'Учебник'
        tasks: 'Задачник'
        practice: 'Практика'
        quiz: 'Билеты'
        other: 'Другое'

    schedule:
      details:
        info: 'Информация'
        attachments: 'Приложения'
        close: 'Закрыть'

      navigation:
        session: "Сессия"
        semestr: "Семестр"
        updating: "Обновление..."
        updated: "Обновлено"
        groups: "Группы"
        next_week: "Следующая неделя"


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
    @transferPropsTo(span {}, getLocalizedValue(@state.locale, path))