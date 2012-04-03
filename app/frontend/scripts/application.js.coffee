//= require jquery.pjax

$(document).ready () ->
  $('.selector a')
    .pjax('#visual', {fragment: '#visual'})
    .live 'click', () ->
      return false