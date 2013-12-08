angular.module('app.filters')
.value('now', new Date())
.filter 'relativeDate', ['now', (now) ->
    (date) ->
      date = new Date(date) unless date instanceof Date
      delta = null

      minute = 60
      hour = minute * 60
      day = hour * 24
      week = day * 7
      month = day * 30
      year = day * 365

      calculateDelta = ->
        delta = Math.round((now - date) / 1000)

      calculateDelta()

      if delta > day && delta < week
        # We're dealing with days now, so time becomes irrelevant
        date = new Date(date.getFullYear(), date.getMonth(), date.getDate(), 0, 0, 0)
        calculateDelta()

      switch
        when delta < 30 then 'только что'
        when delta < minute then "#{delta} секунд назад"
        when delta < 2 * minute then 'минуту назад'
        when delta < hour then "#{Math.floor(delta / minute)} минут назад"
        when Math.floor(delta / hour) == 1 then 'час назад'
        when delta < day then "#{Math.floor(delta / hour)} часов назад"
        when delta < day * 2 then 'вчера'
        when delta < week then "#{Math.floor(delta / day)} дней назад"
        when Math.floor(delta / week) == 1 then 'неделю назад'
        when delta < month then "#{Math.floor(delta / week)} недель назад"
        when Math.floor(delta / month) == 1 then 'месяц назад'
        when delta < year then "#{Math.floor(delta / month)} месяцев назад"
        when Math.floor(delta / year) == 1 then 'год назад'
        else 'более года назад'
  ]