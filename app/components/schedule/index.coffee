{span} = React.DOM
{schedule, classCell, classDetails} = requireComponents('/schedule', 'schedule', 'classCell', 'classDetails')

module.exports = React.createClass
  render: ->
    (schedule {
      cellElem: classCell
      detailsElem: classDetails
      details: {dow: 'Mon', number: "1", data: 'sheet!'}
    })