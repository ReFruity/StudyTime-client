React = require 'react'
_ = require 'underscore'

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

    professors:
      index:
        search: 'Поиск преподавателя'

    attributes:
      professor:
        address: 'Адрес'
        email: 'Почта'
        phone: 'Телефон'

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
      editor:
        add_event: 'Добавить'
        change_event: 'Изменить'
        cancel_event: 'Отменить'
        select_cancel_cell: 'Выберите пару в расписании для отмены'
        select_cell: '<b>Выберите ячейку в расписанни,</b><br /> чтобы добавить в нее пару'

      event:
        types:
          lecture: 'лекция'
          practice: 'практика'
          exam: 'экзамен'
          test: 'зачет'
          consult: 'консультация'

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
@locale = 'ru'
@t = @getLocalizedValue = _.memoize((path, locale=@locale) ->
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
    @transferPropsTo(span {dangerouslySetInnerHTML: {__html: getLocalizedValue(path, @state.locale)}})