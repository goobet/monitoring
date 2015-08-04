$ ->
  charts = $('.chart>div').map (index, item) ->
    jitem = $(item)

    chart =
      highchart: jitem.highcharts()
      name: jitem.attr 'id'
      counts: []

  $('.machine-name').click (e) ->
    charts.each (ind, chart) ->
      $.each chart.highchart.series, (i, series) ->
        if series.name == e.target.text
          series.show()
        else
          series.hide()

  setInterval ->
    $.getJSON '/stats', (data) ->

      $('#online_list tbody tr').each (index, row) ->
        $.each data[index], (param, value) ->
          if param == 'hostname'
            $(row).children('.' + param + ' a').text value
          else
            $(row).children('.' + param).text value

      charts.each (i, chart) ->
        $.each data, (index, state) ->
          if chart.counts[index] == undefined
            chart.counts[index] = chart.highchart.series[index].data.length

          shift = chart.counts[index] >= 120

          chart.counts[index]++ unless shift

          time_now = (new Date).getTime()
          time_now -= time_now % 5000

          chart.highchart.series[index].addPoint [
            time_now
            +state[chart.name]
          ], false, shift

        chart.highchart.redraw()
  , 5000  