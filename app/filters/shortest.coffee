angular.module('app.filters')
.filter 'shortest', [->
    endless = {'а': yes, 'у': yes, 'о': yes, 'ы': yes, 'и': yes, 'э': yes, 'я': yes, 'ю': yes, 'ё': yes, 'е': yes, 'ь': yes, 'ъ': yes}
    removeEndless = (str) ->
      if str.length > 1 and endless[str[str.length - 1]]
        return removeEndless(str.substring(0, str.length - 1))
      return str

    (text) ->
      parts = text.split(' ')
      if parts.length > 1
        part_len = Math.round(6 / parts.length)
        if part_len <= 1
          return (p[0].toUpperCase() for p in parts).join("")
        else
          symbols_len = 0
          symbols = []
          for p in parts
            r_part = removeEndless(p.substr(0, part_len))
            symbols_len += r_part.length
            symbols.push(r_part)
          if symbols_len == parts.length
            return symbols.join("").toUpperCase()
          else
            return ( (if s.length == 1 then s+" " else s + ". ") for s in symbols).join("")

      else
        if text.length > 7
          return removeEndless(text.substr(0, 7)) + "."
        else
          return text
  ]