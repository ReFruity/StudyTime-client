angular.module('app.filters')
.filter 'redeableSize', [->
    (n) ->
      n = parseInt(n)
      if n == undefined || /\D/.test(n)
          return ""
      if n > 1073741824
          return Math.round(n / 1073741824, 1) + " Gb"
      if n > 1048576
          return Math.round(n / 1048576, 1) + " Mb"
      if n > 1024
          return Math.round(n / 1024, 1) + " Kb"
      return n + " b"
  ]