{span, div, a, h2, i, ul, li, input} = React.DOM
{i18n, clickOutside, upload} = requireComponents('/common', 'i18n', 'clickOutside', 'upload')

##
# Component for header of attachments. There is header text
# and some attachments controls like new att button or search
#
AttHeader = React.createClass
  propTypes:
    uploadFileHandler: React.PropTypes.func.isRequired

  render: ->
    (div {className: 'att-header'}, [
      (h2 {}, [
        (i18n {}, 'attachments.header')
      ])
      (AddAttachemtnBtn {uploadFileHandler: @props.uploadFileHandler})
    ])


##
# Button for creating new attachment to the subject
# Can start uploading file or creating a link of selected
# attachment type
#
AddAttachemtnBtn = React.createClass
  mixins: [clickOutside]
  propTypes:
    uploadFileHandler: React.PropTypes.func.isRequired

  getDefaultProps: ->
    categories: ['note', 'book', 'tasks', 'practice', 'quiz', 'other']

  getInitialState: ->
    attType: 'file'
    showDropDown: false

  switchAttType: (type)->
    @setState
      attType: type

  toggleDropDown: ->
    @setState
      showDropDown: !@state.showDropDown

  onClickOutside: ->
    @setState
      showDropDown: false

  render: ->
    self = @
    (div {className: 'hedaer-add-att'}, [
      (a {onClick: @toggleDropDown}, [
        (i {className: 'stico-plus'})
        (i18n {}, 'attachments.add')
      ])
      (if @state.showDropDown
        (div {className: 'drop-down'}, [
          (ul {className: 'att-type-switcher'}, [
            (li {className: ('current' if @state.attType == 'file'), onClick: (->
              self.switchAttType('file'))}, [
              (i18n {}, 'attachments.file')
            ])
            (li {className: ('current' if @state.attType == 'link'), onClick: (->
              self.switchAttType('link'))}, [
              (i18n {}, 'attachments.link')
            ])
          ])

          (ul {className: 'att-type-switcher'},
            @props.categories.map (cat) ->
              (li {}, [
                (if self.state.attType == 'file'
                  (upload {uploadFileHandler: self.props.uploadFileHandler, className: 'att-file-input', properties: {category: cat}})
                )
                (i18n {}, "attachments.types.#{cat}")
              ])
          )
        ])
      )
    ])


##
# Container for in progress attachments
#
AttProgressContainer = React.createClass
  render: ->
    (span {}, 'attachments')


##
# Container for currently uploaded attachments
#
AttContainer = React.createClass
  render: ->
    (span {}, 'attachments')

##
# Represents attachment item (uploading or already uploaded).
# Can handle uploading progress and has editing mode.
#
AttItem = React.createClass
  render: ->
    (span {}, 'attachments')


##
# Main component of attachments
# It binds to subject attachments collection.
# Gives `data` property with event object
#
module.exports = React.createClass
  propTypes:
    data: React.PropTypes.object.isRequired

  getInitialState: ->
    uploaders: []
    files: []

  onUploadFile: (fileUploader) ->
    @state.uploaders.push(fileUploader)
    @forceUpdate()

  render: ->
    (div {className: 'container class-att'}, [
      (AttHeader {uploadFileHandler: @onUploadFile})
      (if @state.uploaders.length > 0
        (AttProgressContainer {uploaders: @state.uploaders})
      )
      (if @state.files.length > 0
        (AttContainer {files: @state.files})
      )
    ])