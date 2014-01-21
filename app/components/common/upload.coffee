{input} = React.DOM


class FileUploader
  constructor: (@file) ->

  start: ->
    if @file.errors
      throw new Error('Cant start file uploading until it has errors')

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
      success: (response)->
        if self.props.success
          self.props.success(response)
      error: (jqXHR) ->
        if @props.fail
          self.props.fail(jqXHR)

  registerUploaded: ->
    console.log 'register'

  collateFormData: ->
    files = @getDOMNode().files
    formData = new FormData()
    if @props.id
      formData.append('reactUpload_id', @props.id);
    if @props.customParams
      for k of @props.customParams
        formData.append(k, @props.customParams[k]);
    for f in files
      formData.append(@props.name + '[]', f);
    return formData

  success: (func) ->
    @success = func
    return this

  progress: (func) ->
    @progress = func
    return this

  error: (func) ->
    @error = func
    return this

##
# HTML5 upload input form
# Uploads by $.ajax to Amazon S3
#
module.exports = React.createClass
  propTypes:
    allowedFileTypes: React.PropTypes.string
    maxSizeInBytes: React.PropTypes.number
    uploadFileHandler: React.PropTypes.func.isRequired
    properties: React.PropTypes.object

  getDefaultProps: ->
    maxSizeInBytes: 104857600
    properties: {}

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
    @getDOMNode().files.map (file) ->
      self.props.uploadFileHandler(new FileUploader(_.assign(file, self.props.properties)))

  render: ->
    @transferPropsTo(input {type: "file", onChange: @onFileSelected})