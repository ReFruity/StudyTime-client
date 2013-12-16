'use strict'
angular.module('app.controllers')
.value('uploadingFiles', {})
.controller('ClassAttachmentsCtrl', [
    '$scope'
    '$upload'
    'uploadingFiles'
    'Subject'

    ($scope, $upload, uploadingFiles, Subject) ->
      # Get current uploading files
      if not uploadingFiles[$scope.clazz._id]
        uploadingFiles[$scope.clazz._id] = []
      $scope.uploadingFiles = uploadingFiles[$scope.clazz._id]

      # Create form for adding link
      $scope.addLink = (type) ->
        $scope.showUploadDropdown = false

      # Upload files to server
      $scope.onFileSelect = ($files, type) ->
        $scope.showUploadDropdown = false

        # Add uploading items to scope's uploadingFiles array
        # ...

        # Sign uploading and start it
        Subject.sign_upload().then((sign)->
          for file in $files
            $scope.upload = $upload.upload(
              url: 'https://studytime-files.s3.amazonaws.com:443/'
              method: 'POST'
              data:
                utf8: 'true'
                filename: '${filename}'
                AWSAccessKeyId: 'AKIAJAGWQEQFFYROMVKQ'
                acl: 'public-read'
                policy: sign.policy
                signature: sign.signature
                success_action_status: '201'
                key: sign.prefix + '${filename}'
              file: file
            ).progress((evt) ->
              console.log('percent: ' + parseInt(100.0 * evt.loaded / evt.total));
            ).success((data, status, headers, config) ->
              console.log(data)
            )
        )
  ])