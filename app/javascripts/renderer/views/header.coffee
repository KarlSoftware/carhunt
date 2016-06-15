$ = require('jquery')
electron = require('electron')
Marionette = require('backbone.marionette')
Filter = require('coffee!./../models/filter.coffee')

class Header extends Marionette.ItemView
  getTemplate: => require('handlebars!../templates/header.hbs')

  ui:
    filter: '.js-filter'
    loadData: '.js-load-data'

  events:
    'change @ui.filter': 'onChangeFilter'
    'click @ui.loadData': 'onClickLoadData'

  serializeData: ->
    years: [2016..2000]
    miles: [20000, 35000, 50000, 75000, 100000, 125000, 150000, 200000]
    prices: [2000, 5000, 10000, 20000, 30000, 40000, 50000, 65000, 80000, 100000, 200000]

  initialize: ->
    @filters = @options.filters

  onRender: ->
    console.log 'render header'
    for key, val of @filters.attributes
      @$el.find("[name='#{key}'] option[value='#{val}']").prop('selected', true)

  onChangeFilter: (e) ->
    $filter = $(e.currentTarget)
    @filters.set $filter.attr('name'), $filter.val()
    @filters.store()

  onClickLoadData: ->
    @ui.loadData.addClass('loading')
    electron.ipcRenderer.send 'data:load'

module.exports = Header
