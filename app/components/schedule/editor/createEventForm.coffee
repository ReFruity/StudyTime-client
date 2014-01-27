{span, div, a, ul, li, i, form, input, label, select, option, textarea, button} = React.DOM
{i18n, dateTimePicker} = requireComponents('/common', 'i18n', 'dateTimePicker')
{classSet} = React.addons

##
# Show a form for creating/changing event (or replacement)
# On submit it invoke handler, that can creates new event
# by given state of this component.
#
module.exports = React.createClass
  propTypes:
    date: React.PropTypes.object
    number: React.PropTypes.string
    timing: React.PropTypes.object
    state: React.PropTypes.object
    submitHandler: React.PropTypes.func.isRequired
    switchEditorHandler: React.PropTypes.func

  getDefaultProps: ->
    autoEnd: yes
    onlyInGrid: yes

  # If date and number given in props, set
  # day of week, class number and activity
  # in initial state.
  getInitialState: ->
    @createStateByProps(@props)

  # Simple field setters
  setSubject: (e)->
    @setState subject: e.target.value

  setProfessor: (e)->
    @setState professor: e.target.value

  setPlace: (e)->
    @setState place: e.target.value

  setEventType: (e)->
    @setState type: e.target.value

  setParity: (e)->
    @setState parity: e.target.value

  setHalfGroup: (e)->
    @setState half_group: e.target.value

  setDescription: (e)->
    @setState description: e.target.value

  # Try to set activity if given date is
  # not undefined. Also try to set new class
  # number if given start and end time exists in
  # timing
  setActivityStart: (date)->
    # Update state
    if date
      number = @getClassNumberByActivity(date, @state.activity_end)
      end = new Date(date)
      end.setFullYear(date.getFullYear(), date.getMonth(), date.getDate()+1)
      @setState
        number: number
        dow: date.getDay()
        activity_start: date
        activity_end: (if @state.activity_end and @state.activity_end < date then end else @state.activity_end)

      # Update schedule selector
      @props.switchEditorHandler(1, {date: date, number: number}) if @props.switchEditorHandler

  # Update activity.end if given date is
  # not undefined
  setActivityEnd: (date)->
    if date
      @setState
        number: @getClassNumberByActivity(@state.activity_start, date)
        activity_end: date

  # Handle changing of day of week. Also update
  # activity_start date
  setDayOfWeek: (e)->
    if e.target.value >= 0
      # Update state
      start = new Date(@state.activity_start)
      start.setDate(start.getDate() + (e.target.value - start.getDay()))
      @setState
        dow: e.target.value
        activity_start: start

      # Update schedule selector
      @props.switchEditorHandler(1, {date: start, number: @state.number}) if @props.switchEditorHandler

  # Handle changing of class number. Update class number
  # only if timing exists. Also set new start and end time
  # in activity
  setClassNumber: (e)->
    if e.target.value > 0 and @props.timing
      # Update state
      start = new Date(@state.activity_start)
      start.setHours(0, @props.timing[e.target.value+""].start, 0, 0)
      end = new Date(@state.activity_end)
      end.setHours(0, @props.timing[e.target.value+""].end, 0, 0)
      @setState
        number: e.target.value+""
        activity_start: start
        activity_end: end

      # Update schedule selector
      @props.switchEditorHandler(1, {date: start, number: e.target.value+""}) if @props.switchEditorHandler

  # By given start and end date try to get
  # class number with help of timing
  getClassNumberByActivity: (start, end)->
    try
      if @props.timing and start and end
        end = new Date(end)
        start = new Date(start)
        mins_start = start.getHours()*60 + start.getMinutes()
        mins_end = end.getHours()*60 + end.getMinutes()

        for k of @props.timing
          if @props.timing[k].start == mins_start and @props.timing[k].end == mins_end
            return (k+"")

    return undefined

  # Update activity and state when receive new props
  componentWillReceiveProps: (props)->
    @setState @createStateByProps(props)

  # Generate state of the form by given props
  createStateByProps: (props) ->
    # Get state from props
    newState = {}
    if props.state
      _.assign(newState, props.state)

    # Set new activity, dow and class number
    if props.date and props.number and @props.timing
      start = new Date(props.date)
      start.setHours(0, @props.timing[props.number].start, 0, 0)
      end = new Date(props.date)
      end.setHours(0, @props.timing[props.number].end, 0, 0)
      _.assign(newState,
        dow: start.getDay()
        number: props.number
        activity_start: start
        activity_end: (if @props.autoEnd then @getNearestEventEnd(end) else end)
      )

    # Return new state
    newState

  # Return expected end of the semester
  getNearestEventEnd: (date)->
    date = new Date(date)
    if date.getMonth() < 6
      date.setMonth(5, 1)
    else
      date.setMonth(11, 24)
    date

  # Save event model
  onSubmitForm: (e)->
    e.preventDefault()
    console.log "submit"

  render: ->
    (div {className: 'cr-event'}, [
      (form {onSubmit: @onSubmitForm, role: 'form'}, [
        # Professor, Subject
        (div {className: 'row'}, [
          (div {className: 'col-xs-6 form-group'}, [
            (label {className: classSet('sr-only': not @state.subject), htmlFor: 'subjectInput'}, 'Название предмета')
            (input {id: 'subjectInput', className: 'form-control', placeholder: 'Название предмета', value: @state.subject, onChange: @setSubject})
          ])
          (div {className: 'col-xs-6 form-group'}, [
            (label {className: classSet('sr-only': not @state.professor), htmlFor: 'proffInput'}, 'Преподаватель')
            (input {id: 'proffInput', className: 'form-control', placeholder: 'Преподаватель', value: @state.professor, onChange: @setProfessor})
          ])
        ])

        # Place, Event type, Start date, End date
        (div {className: 'row'}, [
          (div {className: 'col-xs-3 form-group'}, [
            (label {className: classSet('sr-only': not @state.place), htmlFor: 'placeInput'}, 'Аудитория')
            (input {id: 'placeInput', className: 'form-control', placeholder: 'Аудитория', value: @state.place, onChange: @setPlace})
          ])
          (div {className: 'col-xs-3 form-group'}, [
            (label {className: classSet('sr-only': not @state.type), htmlFor: 'typeInput'}, 'Тип события')
            (select {id: 'typeInput', className: 'form-control', value: @state.type, onChange: @setEventType}, [
              (option {value: undefined}, '-- Тип события --')
              (option {value: 'lecture'}, 'Лекция')
              (option {value: 'practice'}, 'Практика')
              (option {value: 'exam'}, 'Экзамен')
              (option {value: 'test'}, 'Зачет')
              (option {value: 'consult'}, 'Консультация')
            ])
          ])
          (div {className: 'col-xs-3 form-group'}, [
            (label {className: classSet('sr-only': not @state.activity_start), htmlFor: 'startDateInput'}, 'Дата и Время начала')
            (dateTimePicker {maxView: (if @props.onlyInGrid then 'date' else 'minutes'), id: 'startDateInput', className: 'form-control', placeholder: 'Дата и Время начала', value: @state.activity_start, onChange: @setActivityStart})
          ])
          (div {className: 'col-xs-3 form-group'}, [
            (label {className: classSet('sr-only': not @state.activity_end), htmlFor: 'endDateInput'}, 'Дата и Время окончания')
            (dateTimePicker {maxView: (if @props.onlyInGrid then 'date' else 'minutes'), id: 'endDateInput', className: 'form-control', after: @state.activity_start, placeholder: 'Дата и Время окончания', value: @state.activity_end, onChange: @setActivityEnd})
          ])
        ])

        # Day of week, Class number, Parity, Group part
        (div {className: 'row'}, [
          (div {className: 'col-xs-3 form-group'}, [
            (label {className: classSet('sr-only': not @state.dow), htmlFor: 'dowInput'}, 'День недели')
            (select {id: 'dowInput', className: 'form-control', value: @state.dow, onChange: @setDayOfWeek}, [
              (option {value: undefined}, '-- День недели --')
              (option {value: 1}, 'Понедельник')
              (option {value: 2}, 'Вторник')
              (option {value: 3}, 'Среда')
              (option {value: 4}, 'Четверг')
              (option {value: 5}, 'Пятница')
              (option {value: 6}, 'Суббота')
              (option {value: 0}, 'Воскресенье')
            ])
          ])
          (div {className: 'col-xs-3 form-group'}, [
            (label {className: classSet('sr-only': not @state.number), htmlFor: 'typeInput'}, 'Номер пары')
            (select {id: 'typeInput', className: 'form-control', value: @state.number, onChange: @setClassNumber}, [
              (option {value: undefined}, '-- Номер пары --')
              (option {value: 1}, '1')
              (option {value: 2}, '2')
              (option {value: 3}, '3')
              (option {value: 4}, '4')
              (option {value: 5}, '5')
              (option {value: 6}, '6')
            ])
          ])
          (div {className: 'col-xs-3 form-group'}, [
            (label {className: classSet('sr-only': not @state.parity), htmlFor: 'parityInput'}, 'Повторяемость')
            (select {id: 'parityInput', className: 'form-control', value: @state.parity, onChange: @setParity}, [
              (option {value: undefined}, '-- Повторяемость --')
              (option {value: 0}, 'Каждую неделю')
              (option {value: 2}, 'По четным')
              (option {value: 1}, 'По нечетным')
            ])
          ])
          (div {className: 'col-xs-3 form-group'}, [
            (label {className: classSet('sr-only': not @state.half_group), htmlFor: 'hgInput'}, 'Часть гргуппы')
            (select {id: 'hgInput', className: 'form-control', value: @state.half_group, onChange: @setHalfGroup}, [
              (option {value: undefined}, '-- Часть группы --')
              (option {value: 0}, 'Вся группа')
              (option {value: 1}, 'Первая подгруппа')
              (option {value: 2}, 'Вторая подгруппа')
            ])
          ])
        ])

        # Description
        (div {className: 'row'}, [
          (div {className: 'col-xs-12 form-group'}, [
            (label {className: classSet('sr-only': not @state.description), htmlFor: 'descInput'}, 'Описание')
            (textarea {id: 'descInput', className: 'form-control', placeholder:'Описание', value: @state.description, onChange: @setDescription})
          ])
        ])

        # Add/Cancel buttons
        (div {className: 'row'}, [
          (div {className: 'col-xs-12 form-group'}, [
            (button {className: 'btn btn-success form-control'}, 'Добавить')
          ])
        ])
      ])
    ])