{span, div} = React.DOM
{classSet} = React.addons

module.exports = React.createClass
  propTypes:
    data: React.PropTypes.array
    date: React.PropTypes.object
    dow: React.PropTypes.string
    number: React.PropTypes.string

  render: ->
    (div {className: 'class-cell'}, (
      if @props.data
        @props.data.map (atom)->
          (div {className: "cell-atom parity-#{atom.parity} hg-#{atom.half_group}"}, [
            (span {className: 'atom-name'}, atom.subject.name)
            (div {className: 'atom-places'}, (atom.place or []).map (place) ->
              (span {}, place.name)
            )
          ])
    ))