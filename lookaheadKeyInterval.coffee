
$ = jQuery
$.fn.extend

  # text: string to insert into every matched element
  # callback: function() to be called when text has been inserted into each elem
  # keypress: function(index) called after every keypress
  typetype: (text, callback, keypress) ->

    charDelay = 100

    # function returns the delay before the next character
    interval = (index) ->
      lastchar = text[index-1]
      nextchar = text[index]
      return Math.random()*charDelay * switch lastchar
        # fast repeat keys
        when nextchar then 1.6
        # pause after punctuation
        when '.', '!' then 16
        when ',', ';' then 8
        # pause for spaces
        when ' ' then 3
        # pause at the end of lots of newlines
        when lastchar is '\n' and nextchar isnt '\n' then 10
        else 2


    deferreds = for t in @
      do (t) ->
        $.Deferred( (deferred) ->

          # do all the typing for the single textarea, `t`
          updateChar = (limit) ->
            # append one char
            $(t).html(text.substr(0,limit))
            keypress?.call(t, limit)

            # timeout recurse
            if limit < text.length
              setTimeout () ->
                updateChar(limit+1)
              , interval(limit)  # interval depends on position in string
            else
              deferred.resolve()

          # start it all off immediately!
          updateChar(1)
        ).done(() -> callback?.call(t))

    # combined promise of all of them
    return $.when(deferreds...) # ie $.when(d1, d2)   NOT   $.when([d1,d2])