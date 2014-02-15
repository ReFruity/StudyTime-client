React = require 'react'
$ = require 'jquery'
config = require 'config/config'
_ = require 'underscore'
{input} = React.DOM


class FileUploader
  constructor: (@file, @att, @sched, @photo) ->
    @name = @file.name
    @size = @file.size
    @errors = @file.errors
    @s3 = yes
    @uploader = yes
    @editor = yes

  start: ->
    if @errors
      throw new Error('Cant start file uploading until it has errors')

    # First of all register uploader
    @signUpload().done (sign)->
      console.log sign

      # Create FormData
      formDate = collateFormData(sign)
      self = @

      # Send file
      $.ajax
        xhr: ->
          xhr = new XMLHttpRequest();
          xhr.upload.addEventListener('progress', (evt) ->
            if evt.lengthComputable and self.progress
              self.progress(Math.floor((evt.loaded / evt.total) * 100))
          , false)
          xhr
        url: 'https://studytime-files.s3.amazonaws.com:443/',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false

  signUpload: ->
    $.ajax
      url: "#{config.apiUrl}/upload/sign"
      type: 'POST'
      contentType: "application/json; charset=utf-8"
      dataType: "json",
      data: JSON.stringify ((
        if @att
          type: 'attachment'
          subject: @att.subject
        else if @sched
          type: 'schedule'
          uni: @sched.uni
          faculty: @sched.faculty
        else if @photo
          type: 'photo'
          user: @photo.user
        else
          throw new Error('Type of attachment not specified')
      ))


  collateFormData: (sign)->
    files = @getDOMNode().files
    formData = new FormData()
    ###
    if @props.id
      formData.append('reactUpload_id', @props.id);
    if @props.customParams
      for k of @props.customParams
        formData.append(k, @props.customParams[k]);
    for f in files
      formData.append(@props.name + '[]', f);
    ###
    formData

  progress: (func) ->
    @progress = func
    this

##
# HTML5 upload input form for uploading attachments to some subject
# in some category. Uploads by $.ajax to Amazon S3.
#
module.exports = React.createClass
  propTypes:
    allowedFileTypes: React.PropTypes.string
    maxSizeInBytes: React.PropTypes.number
    uploadFileHandler: React.PropTypes.func.isRequired
    attachment: React.PropTypes.object
    schedule: React.PropTypes.object
    photo: React.PropTypes.object

  getDefaultProps: ->
    maxSizeInBytes: 204857600

  validateFiles: ->
    errors = false
    for f in @getDOMNode().files
      errorsArray = @findErrors(f)
      if errorsArray.length > 0
        f.errors = errorsArray
        errors = yes
    return not errors

  findErrors: (file) ->
    errorsArray = [];
    if @props.allowedFileTypes and file.type not in @props.allowedFileTypes.split(',')
      errorsArray.push(type: 'type', rule: @props.allowedFileTypes, given: file.type)
    if @props.maxSizeInBytes and file.size > @props.maxSizeInBytes
      errorsArray.push(type: 'size', rule: @props.maxSizeInBytes, given: file.size)
    return errorsArray

  onFileSelected: ->
    self = @
    @validateFiles()
    _.map @getDOMNode().files, (file) ->
      self.props.uploadFileHandler(new FileUploader(file, self.props.attachment, self.props.schedule, self.props.photo))

  render: ->
    @transferPropsTo(input {type: "file", onChange: @onFileSelected})


