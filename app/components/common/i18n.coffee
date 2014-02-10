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

    num_text:
      class: ['пара', 'пары', 'пар']
      week: ['неделя', 'недели', 'недель']
      on_week: ['неделю', 'недели', 'недель']

    layouts:
      main:
        site_name: "StudyTime"
        about: "О проекте"
        terms: "Соглашение"
        authors: "Кто авторы?"
        login: 'Вход'
        navigation:
          schedule: "Расписание"
          places: "Аудитории"
          courses: "Спецкурсы"
          professors: "Преподы"
          index: 'Главаня'
          about: 'О нас'
          tour: 'Тур по сайту'

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
      back: 'Назад'

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
      texts:
        no_staff: '<h3>С прискорбием сообщаем Вам, что в этой группе <br/> еще не объявился староста</h3><p>Может быть староста – это вы? Или может быть вы с ним знакомы?<br />Без старосты расписание некому заполнять и поддерживать!</p>'
        welcome_staff: '<h1>С днем рождения, группа!</h1><p>Сегодняшний день можно смело назвать днем рождения группы.<br />Ведь не каждый день у группы появляется староста.<br />Но об этом пока никто не знает, поэтому самое время...</p>'

      editor:
        add_event: 'Добавить'
        change_event: 'Изменить'
        cancel_event: 'Отменить'
        select_cancel_cell: 'Выберите пару в расписании для отмены'
        select_cell: '<b>Выберите ячейку в расписанни,</b><br /> чтобы сделать в ней изменение'
        enter_subj: '← Введите предмет и тип'
        enter_proff: 'нет преподавателя'
        enter_place: 'нет аудитории'

      event:
        hg:
          0: 'Вся группа'
          1: 'Первая подгруппа'
          2: 'Вторая подгруппа'
        parity:
          0: 'Каждую неделю'
          1: 'По нечетным'
          2: 'По четным'
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

# Numerical texts translation
@nt = (number, title, locale=@locale) ->
  cases = [2, 0, 1, 1, 1, 2]
  titles = data[locale].num_text[title]
  titles[(if (number % 100 > 4 and number % 100 < 20) then 2 else cases[(if (number % 10 < 5) then number % 10 else 5)])]

# Rendering
{span} = React.DOM
module.exports = React.createClass
  getInitialState: ->
    locale: 'ru'

  render: ->
    path = if _.isArray(@props.children) then @props.children[0] else @props.children
    @transferPropsTo(span {dangerouslySetInnerHTML: {__html: getLocalizedValue(path, @state.locale)}})