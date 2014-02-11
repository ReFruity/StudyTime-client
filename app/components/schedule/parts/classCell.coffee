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

  # Fast(realy?) unique cell id generator, that creates string
  # contains any variable things of the cell
  getCellUniqueId: (p, s)->
    """
      #{not p.route.dow or not p.route.number or p.route.dow != p.dow or p.route.number != p.number}
      #{((p.data or []).map (a)-> a.subject.name+((a.place or []).map (p)->p.name).join('.')+a.parity+a.half_group+a.type).join('.')}
      #{p.bounds[0].getTime()}.#{p.bounds[1].getTime()}
      #{if p.editor and p.editor.state and p.editor.state.number == p.number and p.editor.state.dow == p.dow then JSON.stringify(p.editor) else p.editor.mode}
      #{p.route.atom if p.route.dow == p.dow and p.route.number == p.number}
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

    act.start <= bounds[0] < act.end or act.start < bounds[1] <= act.end or (bounds[0] <= act.start and bounds[1] >= act.end)

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
        parity: 0
        half_group: 0
        activity_start: @props.date
      )
      when 2, 3 then _.assign(newEditorState,
        parity: atom.parity
        half_group: atom.half_group
        place: atom.place or []
        type: atom.type
        subject: atom.subject
        professor: atom.professor or []
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
        @props.date.isSameDate(@props.editor.state.activity_start)
      when 2, 3 then @props.editor.state._id == atom._id and
        @props.date.isSameDate(@props.editor.state.activity_start)
      else no

  # View renderer
  render: ->
    self = @
    div {className: 'cell-wrapper'}, [
      if @props.editor.mode == 1
        div {ref: 'editorCell', className: 'editor-cell'},
          a {onMouseDown: @updateEditorState, className: "editor-atom cell-atom parity-0 hg-0 #{if @isCurrentEditorCell() then 'current' else ''}"}, 'добавить'

      div {className: 'class-cell'}, [
        _.map _.filter(@props.data or [], @filterCellAtoms), (atom, index) -> [
          if self.props.editor.mode in [2,3]
            a {onMouseDown: (->self.updateEditorState(atom)), className: "editor-atom cell-atom parity-#{atom.parity} hg-#{atom.half_group} #{if self.isCurrentEditorCell(atom) then 'current' else ''}"},
              switch self.props.editor.mode
                when 2 then 'отменить'
                when 3 then 'изменить'

          a {href: self.getDetailsHref(atom, index), className: "cell-atom parity-#{atom.parity} hg-#{atom.half_group}"}, [
            i {className: 'stico-lection'} if atom.type == 'lecture'
            span {className: 'atom-name'}, atom.subject.name
            div {className: 'atom-places'}, self.getAtomPlaces(atom).map (place) ->
              span {}, place.name
          ]
        ]
      ]
    ]