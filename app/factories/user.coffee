angular.module('app.services')
.factory("User", [
    '$q'
    '$http'
    'localStorageService'
    'config'
    '$timeout'
    'Cachier'
    '$rootScope'
    '$window'

    ($q, $http, localeStorage, config, $timeout, Cachier, $rootScope, $window) ->
      auth: ->
        defer = $q.defer()
        $timeout(->
          # Allow popup to access to opener
          document.domain = 'studytime.me'
          wnd = $window.open('https://oauth.vk.com/authorize?client_id=3509560&redirect_uri=http://api.studytime.me/api/v2/auth/vk&display=popup&scope=&v=5.5&response_type=code',
            'VK Auth', 'height=400,width=600')
          if window.focus then wnd.focus()

          # Login callbacks
          $window.loginCallback =
            onFailed: ->
              defer.reject(false)
            onSuccess: (user)->
              $rootScope.$emit('userAuthenticated', user)
              defer.resolve(user)
        )
        defer.promise

      logged_in_user: ->
        $http(
          withCredentials: true
          method: 'GET'
          url: "#{config.apiUrl}/user/current"
        )
  ])

# Authentication logic
.run [
    '$rootScope'
    'User'

    ($rootScope, User)->
      # Register authenticated user in the system
      onUserAuthenticated = (user) ->
        $rootScope.currentUser = user
        if 'su' in user.roles
          $rootScope.$isAdmin = yes

      # Try to get current logged in user
      $rootScope.$on 'userAuthenticated', (etv, user)->
        onUserAuthenticated(user)
      User.logged_in_user().success(onUserAuthenticated)
  ]