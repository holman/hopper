//= require jquery.pjax
//= require d3.v2.min

$(document).ready () ->
  $('.selector a')
    .pjax('#visual', {fragment: '#visual'})
    .live 'click', () ->
      return false

  if $('.graph').length > 0
    $('.bar').each (i,e) ->
      element = $(e)
      element.attr('id',"graph-#{i}")

      data = element.data('values').split(' ')

      yScale = d3.scale.linear()
                 .domain([0, d3.max(data)])
                 .range(["10px", "20px"]);

      graph = d3.select("#graph-#{i}")

      graph.selectAll('rect')
            .data(data)
            .enter()
            .append('svg')
            .style('height', yScale)
            .style('width', 25)
            .style('box-shadow', '0 0 5px #ccc')
            .style('border', '3px solid #fff')
            .style('background-color', '#00B4FF')
            .attr('alt', (d) -> d)