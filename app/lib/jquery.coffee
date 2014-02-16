_ = require 'underscore'
defrd = require 'deferred'

# Server side $.ajax implementation
crossPlatformAjax = if typeof window == 'undefined'
  (options) ->
    http = nativeRequire('http')

    throw new Error('You must provide options') if not options
    options.type = 'GET' if not options.type

    deferred = defrd.Deferred()

    if options.type = 'GET'
      if typeof options.data == 'object'
        options.url += '?' + $.param(options.data)

      output = ''

      http.get(options.url, (res)->
        status = res.statusCode
        res.setEncoding('utf8')

        res.on('data', (chunk)->
          output += chunk
        )

        res.on('end', ()->
          if (status >= 200 and status < 300) or (status is 304)
            #console.log options.url + " " + status
            op = JSON.parse output
            #console.log op

            options.success(op) if options.success
            deferred.resolve(op) if deferred
          else
            options.error(output) if options.error
            deferred.reject(output) if deferred
        )
      )

      return deferred.promise()

# Client side $.ajax implementation
else
  (->
    xmlRe = /^(?:application|text)\/xml/
    jsonRe = /^application\/json/

    getData = (accepts, xhr) ->
      accepts = xhr.getResponseHeader("content-type") if not accepts
      if xmlRe.test(accepts)
        xhr.responseXML
      else if jsonRe.test(accepts)
        JSON.parse xhr.responseText
      else
        xhr.responseText

    isValid = (xhr) ->
      (xhr.status >= 200 and xhr.status < 300) or (xhr.status is 304) or (xhr.status is 0 and window.location.protocol is "file:")

    end = (xhr, options, deferred) -> ->
      return if xhr.readyState != 4
      status = xhr.status
      data = getData(options.headers and options.headers.Accept, xhr)

      if isValid(xhr)
        options.success(data) if options.success
        deferred.resolve(data) if deferred
      else
        error = new Error('Server responded with a status of ' + status);
        options.error(xhr, status, error) if options.error
        deferred.reject(xhr) if deferred

    (options) ->
      throw new Error('You must provide options') if not options
      options.type = 'GET' if not options.type
      xhr = _.result(options, 'xhr') or new XMLHttpRequest()
      deferred = defrd.Deferred()
      xhr.withCredentials = yes

      if options.contentType
        options.headers = {} if not options.headers
        options.headers['Content-Type'] = options.contentType;

      if options.type == 'GET' and typeof options.data == 'object'
        query = ''
        stringifyKeyValuePair = (key, value) ->
          if value == null then ''
          else '&' + encodeURIComponent(key) + '=' + encodeURIComponent(value)

        for key of options.data
          query += stringifyKeyValuePair key, options.data[key]

        if query
          sep = if options.url.indexOf('?') == -1 then '?' else '&'
          options.url += sep + query.substring(1)

      options.withCredentials = true if options.credentials
      xhr.addEventListener('readystatechange', end(xhr, options, deferred))
      xhr.open(options.type, options.url, true)
      if options.headers
        for key of options.headers
          xhr.setRequestHeader(key, options.headers[key])
      options.beforeSend(xhr) if (options.beforeSend)
      xhr.send(options.data)
      return deferred.promise()
  )()

##
# Initialize jQeuryMINI
#
$ = ->
  console.log "Create jQeury element"


# For $.param working
r20 = /%20/g
buildParams = (prefix, obj, traditional, add) ->
  if _.isArray(obj)
    _.each obj, (i, v) ->
      if traditional or /\[\]$/.test(prefix)
        add prefix, v
      else
        buildParams prefix + "[" + ((if typeof v is "object" or _.isArray(v) then i else "")) + "]", v, traditional, add
      return
  else if not traditional and obj isnt null and typeof obj is "object"
    _.each obj, (k, v) ->
      buildParams prefix + "[" + k + "]", v, traditional, add
      return
  else
    add prefix, obj
  return


##
# Setup $.Deferred, $.param and cross-platform $.ajax
#
_.extend($,
  ##
  # Deffered
  #
  Deferred: defrd.Deferred

  ##
  # JQuery $.param function without 'traditional'
  #
  param: (a) ->
    s = []
    add = (key, value) ->
      value = (if _.isFunction(value) then value() else value)
      s[s.length] = encodeURIComponent(key) + "=" + encodeURIComponent(value)
      return

    if _.isArray(a)
      _.each a, ->
        add @name, @value
        return
    else
      for prefix of a
        buildParams prefix, a[prefix], no, add

    # Return the resulting serialization
    s.join("&").replace r20, "+"

  ##
  # Lightweight $.ajax implementation
  #
  ajax: crossPlatformAjax
)

# Export our MINI jquery
module.exports = $