{span, div, a, h2, i, ul, li, input, form, button} = React.DOM
{i18n, clickOutside, uploadInput} = requireComponents('/common', 'i18n', 'clickOutside', 'uploadInput')

##
# Component for header of attachments. There is header text
# and some attachments controls like new att button or search
#
AttHeader = React.createClass
  propTypes:
    uploadFileHandler: React.PropTypes.func.isRequired
    data: React.PropTypes.object.isRequired

  render: ->
    (div {className: 'att-header'}, [
      (h2 {}, [
        (i18n {}, 'attachments.header')
      ])
      (AddAttachemtnBtn {uploadFileHandler: @props.uploadFileHandler, data: @props.data})
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
    data: React.PropTypes.object.isRequired

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
                # Upload file
                (if self.state.attType == 'file'
                  (uploadInput {
                    uploadFileHandler: self.props.uploadFileHandler
                    className: 'att-file-input'
                    category: cat
                    subject: self.props.data.subject.object
                  })
                )
                # Add a link
                (i18n {
                  onClick: ->
                    self.props.uploadFileHandler({
                      editor: yes
                      category: cat
                      subject: self.props.data.subject.object
                    })
                }, "attachments.types.#{cat}")
              ])
          )
        ])
      )
    ])

##
# Container for currently uploaded attachments
#
AttContainer = React.createClass
  render: ->
    (div {className: 'att-cont'},
      @props.files.map (file) ->
        (AttItem {file: file})
    )

##
# Represents attachment item (uploading or already uploaded).
# Can handle uploading progress and has editing mode.
#
AttItem = React.createClass
  getInitialState: ->
    uploader:
      percents: 0
      size: 0
      uploaded: 0

  onSubmitEditor: ->

  onCancelEditor: ->

  render: ->
    (div {className: 'att-item'}, (
      if @props.file.editor
        (form {role: "form", onSubmit: @onSubmitEditor}, [
          (div {className: 'row'}, [
            (div {className: 'att-inputs'}, [
              (if not @props.file.s3
                (input {className: 'form-control', type: "url", name: "link", placeholder: "Ссылка", required: yes})
              )
              (input {className: 'form-control', type: "text", name: "name", placeholder: "Название", required: yes})
              (input {className: 'form-control', type: "text", name: "description", placeholder: "Описание"})
            ])
          ])
          (div {className: 'row'}, [
            (div {className: 'done-btn-cont'}, [
              (button {className: 'form-control btn btn-success', type: "submit"}, 'Готово')
            ])
            (if @props.file.uploader
              (div {className: 'progress-cont'}, [
                (span {className: 'percents'}, "#{@state.uploader.percents}%")
                (span {className: 'sizes'}, "#{@state.uploader.size}/#{@state.uploader.uploaded}")
              ])
            )
            (div {className: 'cancel-btn-cont'}, [
              (button {className: 'form-control btn', onClick: @onCancelEditor, type: "button"}, 'Отмена')
            ])
          ])
        ])
      else
        [
          (div {className: 'att-header'}, [
            (a {className: 'name', href: ''}, 'конспекты.pdf')
            (if @props.file.uploader
              (div {className: 'progress-cont'}, [
                (span {className: 'percents'}, "#{@state.uploader.percents}%")
                (span {className: 'sizes'}, "#{@state.uploader.size}/#{@state.uploader.uploaded}")
              ])
            else
              (div {className: 'att-details'},
                (span {className: 'size'}, "#{@props.file.size}")
                (dateFormat {className: 'date', date: @props.file.updated, format: 'dd MMM yyyy'})
              )
            )
          ])
          (div {className: 'att-descr'}, @props.file.description)
        ]
    ))


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
    (div {className: 'class-att'}, [
      (AttHeader {uploadFileHandler: @onUploadFile, data: @props.data})
      (if @state.uploaders.length > 0
        (AttContainer {files: @state.uploaders})
      )
      (if @state.files.length > 0
        (AttContainer {files: @state.files})
      )
    ])