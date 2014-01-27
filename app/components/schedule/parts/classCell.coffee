{span, div, a, i} = React.DOM
{classSet} = React.addons
{i18n, dateFormat} = requireComponents('/common', 'i18n', 'dateFormat')

##
# Component for showing shortest info about class
# in schedule. Can open/hide details by moving to another
# URL
#
# Depending on given `editor.mode` it handles
# clicks on the whole cell or part of cell for pushing to
# editor some useful information (cell coordinates, event id, etc.)
#
module.exports = React.createClass
  propTypes:
    data: React.PropTypes.array
    date: React.PropTypes.object
    dow: React.PropTypes.string
    number: React.PropTypes.string
    baseUrl: React.PropTypes.string.isRequired
    bounds: React.PropTypes.array.isRequired
    editor: React.PropTypes.object.isRequired
    switchEditorHandler: React.PropTypes.func.isRequired
    route: React.PropTypes.object.isRequired

  getCellUniqueId: (p)->
    """
      #{not p.route.dow or not p.route.number or p.route.dow != p.dow or p.route.number != p.number}
      #{((p.data or []).map (a)-> a.subject.name+((a.place or []).map (p)->p.name).join('.')+a.parity+a.half_group+a.type).join('.')}
      #{p.bounds[0].getTime()}.#{p.bounds[1].getTime()}
      #{p.editor.mode}.#{JSON.stringify(p.editor.data)}
      #{p.route.atom if p.route.dow == p.dow and p.route.number == p.number}
    """

  shouldComponentUpdate: (newProps)->
    @getCellUniqueId(@props) != @getCellUniqueId(newProps)

  filterCellAtoms: (atom)->
    bounds = @props.bounds
    act =
      start: new Date(atom.activity.start)
      end: new Date(atom.activity.end)

    if act.start <= bounds[0] < act.end or act.start < bounds[1] <= act.end or (bounds[0] <= act.start and bounds[1] >= act.end)
      yes
    else
      no

  getAtomPlaces: (atom) ->
    if atom.place and atom.place.length > 3
      places = atom.place.slice(0, 3)
      places.push(name: '...')
      places
    else
      atom.place or []

  getDetailsHref: (atom, i) ->
    if @props.route.dow == @props.dow and @props.route.number == @props.number and @props.route.atom == (i + "")
      @props.baseUrl
    else
      "#{@props.baseUrl}/#{@props.dow}-#{@props.number}-#{i}"

  scrollToTop: ->
    scrollHeight = $(window).scrollTop()
    if scrollHeight > 0
      $('#content').animate(translateY: "-#{scrollHeight}px", 0, 'ease', ->
        $(window).scrollTop(0)
        $('#content').animate(translateY: "0px", 300, 'ease', ->
          $('#content').attr('style', '')
        )
      )

  setEditorDate: ->
    @props.switchEditorHandler(@props.editor.mode,
      date: @props.date
      number: @props.number
    )
    @scrollToTop()

  setEditorEvent: (event) ->
    @props.switchEditorHandler(@props.editor.mode,
      event: event
      date: @props.date
    )
    @scrollToTop()

  isCurrentEditorCell: ->
    return no if not @props.editor.data
    switch @props.editor.mode
      when 1 then @props.editor.data.number == @props.number and @isSameDate(@props.editor.data.date, @props.date)
      when 2 then @props.editor.data.event._id == arguments[0]._id and @isSameDate(@props.editor.data.date, @props.date)
      else no

  isSameDate: (nd, cd) ->
    nd.getFullYear() == cd.getFullYear() and nd.getMonth() == cd.getMonth() and nd.getDate() == cd.getDate()

  render: ->
    self = @
    (div {className: 'class-cell'}, [
      (if @props.editor.mode == 1
        (a {className: "editor-cell cell-atom parity-0 hg-0 #{'current' if @isCurrentEditorCell()}", onClick: @setEditorDate},
          #'добавить'
          (dateFormat {date: @props.date, format:"dd MMM EEE, #{@props.number} пара"})
        )
      )
      (@props.data or []).filter(@filterCellAtoms).map (atom, index) -> [
        (if self.props.editor.mode == 2
          (a {
            className: "editor-cell cell-atom parity-#{atom.parity} hg-#{atom.half_group} #{'current' if self.isCurrentEditorCell(atom)}"
            onClick: (->self.setEditorEvent(atom))
          }, 'отменить')
        )
        (a {href: self.getDetailsHref(atom, index), className: "cell-atom parity-#{atom.parity} hg-#{atom.half_group}"}, [
          (i {className: 'stico-lection'}) if atom.type == 'lecture'
          (span {className: 'atom-name'}, atom.subject.name)
          (div {className: 'atom-places'}, self.getAtomPlaces(atom).map (place) ->
            (span {}, place.name)
          )
        ])
      ]
    ])