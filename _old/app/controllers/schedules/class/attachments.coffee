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
      # Initialize attachments
      files_map = {}
      init = ->
        files_map = {}

        # Get current uploading files
        if not uploadingFiles[$scope.clazz.subject.object]
          uploadingFiles[$scope.clazz.subject.object] = []
        $scope.uploadingFiles = uploadingFiles[$scope.clazz.subject.object]

        # Load attachments
        $scope.loading = yes
        $scope.attachments = undefined
        updateAttachments = (atts) ->
          $scope.attachments = atts.attachments

        Subject.attachments($scope.clazz.subject.object).then(updateAttachments, ->
          console.log "cant get attachments"
        , updateAttachments)
        .finally ->
          $scope.loading = no

      # Switch attachments when clazz changed
      $scope.$watch('clazz', init)

      # Create form for adding link
      $scope.addLink = (type) ->
        $scope.showUploadDropdown = false
        file =
          id: "#{Math.random()}#{new Date().getTime()}"
          upl_type: type
          just_link: yes
        file.index = $scope.uploadingFiles.push(file) - 1
        files_map[file.id] = file

      # Upload files to server
      $scope.onFileSelect = ($files, type) ->
        $scope.showUploadDropdown = false

        # Add uploading items to scope's uploadingFiles array
        for file in $files
          file.id = "#{Math.random()}#{new Date().getTime()}"
          file.upl_type = type
          file.displayName = file.name
          file.aborter = $q.defer()
          file.index = $scope.uploadingFiles.push(file) - 1
          file.progress = 0
          file.loaded = 0
          files_map[file.id] = file

        # Sign uploading and start it
        Subject.sign_upload($scope.clazz.subject.object).success((sign)->
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
              file.progress = Math.floor(100.0 * evt.loaded / evt.total)
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
        if file.upload_done or file.just_link
          registerUploaded(file)

      # Abort file uploading
      $scope.abortUpload = (file) ->
        if file.aborter
          file.aborter.resolve()
        removeFileFromUploading(file)

      # Send file registration data to server
      registerUploaded = (file) ->
        file_obj =
          event_id: $scope.clazz._id
          prof_id: (if $scope.clazz.professor and $scope.clazz.professor.length > 0 then $scope.clazz.professor[0].object else undefined)
          name: file.displayName
          creation_date: new Date()
          description: file.description
          type: file.upl_type
          size: file.size
          link: if file.just_link then file.link else file.prefix + file.name
          s3: not file.just_link

        addNewAttachmentToDisplay(file_obj)
        removeFileFromUploading(file)
        Subject.upload_done($scope.clazz.subject.object, file_obj)

      # Removes given file from uploading array
      removeFileFromUploading = (file)->
        $scope.uploadingFiles[file.index] = undefined
        delete files_map[file.id]

      # Add new attachment object to display
      addNewAttachmentToDisplay = (att)->
        if not $scope.attachments
          $scope.attachments = []
        $scope.attachments.unshift(att)
  ])