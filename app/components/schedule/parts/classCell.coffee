_ = require 'underscore'
React = require 'react'
helpers = require 'helpers'
{span, div, a, i} = React.DOM
{classSet} = React.addons
{i18n, dateFormat} = require '/components/common', 'i18n', 'dateFormat'

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

  # State only for tracking mouse over
  # part of the cell (see `onEditorCellMouseOver`)
  getInitialState: ->
    actEdAtom: undefined

  # Fast(realy?) unique cell id generator, that creates string
  # contains any variable things of the cell
  getCellUniqueId: (p, s)->
    """
      #{not p.route.dow or not p.route.number or p.route.dow != p.dow or p.route.number != p.number}
      #{((p.data or []).map (a)-> a.subject.name+((a.place or []).map (p)->p.name).join('.')+a.parity+a.half_group+a.type).join('.')}
      #{p.bounds[0].getTime()}.#{p.bounds[1].getTime()}
      #{if p.editor and p.editor.state and p.editor.state.number == p.number and p.editor.state.dow == p.dow then JSON.stringify(p.editor) else p.editor.mode}
      #{p.route.atom if p.route.dow == p.dow and p.route.number == p.number}
      #{s.actEdAtom.join() if s.actEdAtom}
    """

  # Just compare prev unique cell id and new
  # TODO: maybe save prev cell id?
  shouldComponentUpdate: (newProps, newState)->
    @getCellUniqueId(@props, @state) != @getCellUniqueId(newProps, newState)

  # Filter schedule events for being in given bounds
  filterCellAtoms: (atom)->
    bounds = @props.bounds
    act =
      start: new Date(atom.activity.start)
      end: new Date(atom.activity.end)

    if act.start <= bounds[0] < act.end or act.start < bounds[1] <= act.end or
      (bounds[0] <= act.start and bounds[1] >= act.end) then yes else no

  # Cut atom places to be lte 3. Last filtered place
  # replaced to `...`
  getAtomPlaces: (atom) ->
    if atom.place and atom.place.length > 3
      places = atom.place.slice(0, 3)
      places.push(name: '...')
      places
    else
      atom.place or []

  # Create href for the atom for showing/hidding the details
  getDetailsHref: (atom, i) ->
    if @props.route.dow == @props.dow and @props.route.number == @props.number and @props.route.atom == (i + "")
      @props.baseUrl
    else
      "#{@props.baseUrl}/#{@props.dow}-#{@props.number}-#{i}"

  # Updates editor state depends on current editor mode
  updateEditorState: (atom)->
    # Create initial state
    newEditorState =
      selectedDate: @props.date
      number: @props.number
      dow: @props.dow

    # Set data depends on editor mode
    switch @props.editor.mode
      when 1 then _.assign(newEditorState,
        parity: @state.actEdAtom[0]
        half_group: @state.actEdAtom[1]
        activity_start: @props.date
      )
      when 2, 3 then _.assign(newEditorState,
        parity: atom.parity
        half_group: atom.half_group
        place: atom.place
        type: atom.type
        subject: atom.subject
        professor: atom.professor
        activity_start: (if @props.editor.mode == 2 then @props.date else new Date(atom.activity.start))
        activity_end: new Date(atom.activity.end)
        description: atom.description
        _id: atom._id
      )

    # Update editor and scroll to it
    @props.switchEditorHandler(@props.editor.mode, newEditorState)
    helpers.scrollTop(0)

  # Check that this cell now editing
  isCurrentEditorCell: (atom)->
    return no if not @props.editor.state
    switch @props.editor.mode
      when 1 then @props.editor.state.number == @props.number and
        @isSameDate(@props.editor.state.activity_start, @props.date)
      when 2, 3 then @props.editor.state._id == atom._id and
        @isSameDate(@props.editor.state.activity_start, @props.date)
      else no

  # Check that given two dates (without time) are equal
  isSameDate: (nd, cd) ->
    nd.getFullYear() == cd.getFullYear() and nd.getMonth() == cd.getMonth() and nd.getDate() == cd.getDate()

  # Enable some part of editor cell, that user select by
  # the mouse
  onEditorCellMouseOver: (e) ->
    cellElem = @getDOMNode()
    widthPart = cellElem.offsetWidth / 7
    heightPart = cellElem.parentNode.clientHeight / 13
    position = helpers.findPos(cellElem)
    x = e.pageX - position[0]
    y = e.pageY - position[1]

    # Get half group
    if x <= widthPart*2
      hg = 1
    else if x >= widthPart*5
      hg = 2
    else
      hg = 0

    # Get parity
    if y <= heightPart*4
      parity = 1
    else if y >= heightPart*9
      parity = 2
    else
      parity = 0

    # Set state
    @setState actEdAtom: [parity, hg]

  # Disable any editor atom when mouse leave out from
  # editor cell
  onEditorCellMouseLeave: (e)->
    @setState actEdAtom: undefined

  # View renderer
  render: ->
    self = @
    (div {className: 'class-cell'}, [
      # Show editor cell part selector for making new event
      (if @props.editor.mode == 1
        (div {ref: 'editorCell', className: 'editor-cell', onMouseMove: @onEditorCellMouseOver, onMouseLeave: @onEditorCellMouseLeave},
          (if @props.editor and @props.editor.state and self.isCurrentEditorCell()
            st = @props.editor.state
            (a {className: "editor-atom cell-atom parity-#{st.parity or 0} hg-#{st.half_group or 0} current"})
          )
          (if @state.actEdAtom
            (a {
              className: "editor-atom cell-atom parity-#{@state.actEdAtom[0]} hg-#{@state.actEdAtom[1]}",
              onMouseDown: self.updateEditorState
            }, (
              switch @state.actEdAtom[0]
                when 0 then 'Кажд. нед., '
                when 1 then 'По нечет., '
                when 2 then 'По чет., '
            ) + (
              switch @state.actEdAtom[1]
                when 0 then 'вся группа'
                when 1 then '1 подгр.'
                when 2 then '2 подгр.'
            ))
          )
        )
      )

      # Existing atoms view
      (@props.data or []).filter(@filterCellAtoms).map (atom, index) -> [
        # Show atom editor cell part for canceling/changin
        (if self.props.editor.mode in [2,3]
          (a {
            className: "editor-atom cell-atom parity-#{atom.parity} hg-#{atom.half_group} "+classSet('current': self.isCurrentEditorCell(atom)),
            onClick: (->self.updateEditorState(atom))
          }, (if self.props.editor.mode == 2 then 'отменить' else 'изменить'))
        )

        # Actual cell atom
        (a {href: self.getDetailsHref(atom, index), className: "cell-atom parity-#{atom.parity} hg-#{atom.half_group}"}, [
          (i {className: 'stico-lection'}) if atom.type == 'lecture'
          (span {className: 'atom-name'}, atom.subject.name)
          (div {className: 'atom-places'}, self.getAtomPlaces(atom).map (place) ->
            (span {}, place.name)
          )
        ])
      ]
    ])