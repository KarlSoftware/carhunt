$ = require('jquery')
electron = require('electron')
Marionette = require('backbone.marionette')
Filter = require('coffee!./../models/filter.coffee')

class Header extends Marionette.ItemView
  getTemplate: => require('handlebars!../templates/header.hbs')

  ui:
    filter: '.js-filter'
    filterCheck: '.js-filter-check'
    loadData: '.js-load-data'

  events:
    'change @ui.filter': 'onChangeFilter'
    'change @ui.filterCheck': 'onChangeFilterCheck'
    'click @ui.loadData': 'onClickLoadData'

  serializeData: ->
    years: [2016..2000]
    miles: [20000, 35000, 50000, 75000, 100000, 125000, 150000, 200000]

  initialize: ->
    @filters = @options.filters

  onRender: ->
    for key, val of @filters.attributes
      if key is 'authorized_dealer' and val is true
        @$el.find("[name='authorized_dealer']").prop('checked', true)
      @$el.find("[name='#{key}'] option[value='#{val}']").prop('selected', true)
      @$el.find("input[name='#{key}']").val(val)

  onChangeFilter: (e) ->
    $filter = $(e.currentTarget)
    @filters.set $filter.attr('name'), $filter.val()
    @filters.store()

  onChangeFilterCheck: (e) ->
    $filter = $(e.currentTarget)
    @filters.set $filter.attr('name'), $filter.prop('checked')
    @filters.store()

  onClickLoadData: ->
    @ui.loadData.addClass('loading')
    electron.ipcRenderer.send 'data:load'

module.exports = Header
