//= require jquery.pjax
//= require d3.v2.min

$(document).ready () ->
  # The probe selector
  $('.selector a')
    .pjax('#visual', {fragment: '#visual'})
    .live 'click', () ->
      return false

  if $('.graph').length > 0
    data = $('.graph li').data('values').split(' ').map((e) -> parseInt(e))
    shas = $('.graph li').data('snapshots').split(' ')
    height = 100
    width = 30

    y = d3.scale.linear()
               .domain([0, d3.max(data)])
               .range([height, 0]);

    graph = d3.select(".graph").insert("svg", ":nth-child(3)")

    graph.selectAll('rect')
      .data(data).enter().append('rect')
      .attr('width', width)
      .attr('height', (d) -> height - y(d))
      .attr('x', (d, i) -> i * (width + 5))
      .attr('y', (d) -> y(d))
      .attr('alt', (d) -> d)
      .attr('data-i', (d, i) -> i)

    $('.graph li').click () ->
      data = $(@).data('values').split(' ').map((e) -> parseInt(e))

      y = d3.scale.linear()
               .domain([0, d3.max(data)])
               .range([height, 0]);

      graph.selectAll('rect')
        .data(data)
        .transition()
        .duration(500)
        .attr('height', (d) -> height - y(d))
        .attr('y', (d) -> y(d))
        .attr('alt', (d) -> d)
        .attr('data-i', (d, i) -> i)

    $('.graph rect').hover () ->
      value = $(@).attr('alt')
      $('.info').text(value)

      i = $(@).data('i')
      $('.minor').text(shas[i])
