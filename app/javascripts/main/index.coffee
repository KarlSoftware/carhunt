electron = require('electron')
Q = require('q')
_ = require('lodash')
Bozon = require('./application')
Window = require('./window')
Storage = require('./storage')
DataService = require('./data_service')

class Application extends Bozon

  onReady: (e) ->
    @bindEvents()
    @window = new Window
      onLoad: @onWindowLoad

  bindEvents: ->
    electron.ipcMain.on 'filters:change', (event, data) ->
      console.log 'filters:change event received'
      Storage.setFilters(data)

    electron.ipcMain.on 'sections:change', (event, data) ->
      console.log 'sections:change event received'
      Storage.setSections(data)

    electron.ipcMain.on 'offers:change', (event, data) ->
      console.log 'offers:change event received'
      Storage.setOffers(data)

    electron.ipcMain.on 'skip:change', (event, data) =>
      console.log 'skip:change event received'
      Storage.setSkip(data)

    electron.ipcMain.on 'data:load', (event, data) =>
      console.log 'data:load event received'
      @loadData(true)

  onWindowLoad: =>
    @loadData()

  loadData: (force = false) ->
    Storage.getFilters().then (filters) =>
      @window.send 'header:data', filters: filters
      dataService = new DataService(filters)
      dataService.loadData(force).then (sections) =>
        @window.send 'sections:data', sections: sections

  clearStorage: ->
    Storage.clear().then ->
      console.log 'removed evetything'

module.exports = new Application()
