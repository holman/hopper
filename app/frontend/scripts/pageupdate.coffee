# `pageUpdate` is an event hook for rerunning initialization code
# after new html is inserted or changed. For an example, you may need
# to rebind event observers on new html elements or rewrite HTML in
# JS. It runs automatically on `ready` and after pjax responses but
# must be triggered by hand in other cases.

$(document).ready ->
  $(document.body).pageUpdate()

$(document).on 'pjax:end', (event) ->
  $(event.target).pageUpdate()

$.pageUpdate = (handler) ->
  $(window).pageUpdate handler

$.fn.pageUpdate = (handler) ->
  if handler
    this.on 'pageUpdate', (event) ->
      handler.apply event.target, arguments
    this
  else
    this.trigger 'pageUpdate'