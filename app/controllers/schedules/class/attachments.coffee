'use strict'
angular.module('app.controllers')
.value('uploadingFiles', {})
.controller('ClassAttachmentsCtrl', [
    '$scope'
    '$upload'
    'uploadingFiles'
    'Subject'
    '$q'

    ($scope, $upload, uploadingFiles, Subject, $q) ->
      # Get current uploading files
      if not uploadingFiles[$scope.clazz._id]
        uploadingFiles[$scope.clazz._id] = []
      $scope.uploadingFiles = uploadingFiles[$scope.clazz._id]

      # Load attachments
      $scope.attachments = [
        {
          name: "Вычислительный эусперемент.pdf"
          updated: new Date()
          description: "Тест jgbcfybz"
          link: "upload/2423/sgsdf_fsdf.pdf"
          s3: true
          size: 123412
        },
        {
          name: "Вычислительный эусперемент.pdf"
          updated: new Date()
          description: "Тест jgbcfybz"
          link: "upload/2423/sgsdf_fsdf.pdf"
          s3: true
          size: 123412
        }
      ]
      $scope.professors = [
        {
          name: "Кошелев Антон Александрович"
          object: "234в4а23а43ы3ыы2ы"
        }
        {
          name: "Рогожин Сергей"
          object: "234в4а23а43ы3ыы2ы"
        }
      ]

      # Create form for adding link
      $scope.addLink = (type) ->
        $scope.showUploadDropdown = false

      # Upload files to server
      $scope.onFileSelect = ($files, type) ->
        $scope.showUploadDropdown = false
        files_map = {}

        # Add uploading items to scope's uploadingFiles array
        for file in $files
          file.id = "#{Math.random()}#{new Date().getTime()}"
          file.type = type
          file.displayName = file.name
          file.aborter = $q.defer()
          file.index = $scope.uploadingFiles.push(file) - 1
          files_map[file.id] = file

        # Sign uploading and start it
        Subject.sign_upload($scope.clazz.subject.object).then((sign)->
          for file in $files
            file.prefix = sign.prefix
            file.upload = $upload.upload(
              url: 'https://studytime-files.s3.amazonaws.com:443/'
              method: 'POST'
              timeout: file.aborter.promise
              data:
                name: file.name
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
              file.progress = parseInt(100.0 * evt.loaded / evt.total)
              file.total = evt.total
              file.loaded = evt.loaded
            ).success((data, status, headers, config) ->
              file.upload_done = true
              if file.edit_done
                registerUploaded(file)
            )
        )

      # Must be invoked when user complete editing the file info
      $scope.editDone = (file) ->
        file.edit_done = true
        if file.upload_done
          registerUploaded(file)

      # Send file registration data to server
      registerUploaded = (file) ->
        Subject.upload_done($scope.clazz.subject.object, $scope.clazz._id, file.prefix + file.name, file.displayName,
          file.descr, file.type, true).then(->
            removeFileFromUploading(file)
            addNewAttachmentToDisplay(
              name: file.displayName
              updated: new Date()
              description: file.descr
              size: file.size
              link: file.prefix + file.name
              s3: true
            )
        )

      # Abort file uploading
      abortUpload = (file) ->
        # Abort HTTP request
        file.aborter.resolve()
        removeFileFromUploading(file)

      # Removes given file from uploading array
      removeFileFromUploading = (file)->
        $scope.uploadingFiles[file.index] = undefined
        delete files_map[file.id]

      # Add new attachment object to display
      addNewAttachmentToDisplay = (att)->
        ""
  ])