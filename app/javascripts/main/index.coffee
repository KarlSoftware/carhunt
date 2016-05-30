electron = require('electron')
Q = require('q')
_ = require('underscore')
Bozon = require('./application')
Window = require('./window')
Storage = require('./storage')
Loader = require('./loader')
json = require('../../package.json')

class Application extends Bozon

  onReady: (e) ->
    @bindEvents()
    @window = new Window(json)
    @window.onLoad = => @loadData(true)

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

    electron.ipcMain.on 'data:load', (event, data) =>
      console.log 'data:load event received'
      @loadData()

    electron.ipcMain.on 'skip:change', (event, data) =>
      console.log 'skip:change event received'
      Storage.setSkip(data)

  loadData: (cache = false) ->
    Q.all([
      Storage.getSections(),
      Storage.getFilters()
    ]).then (data) =>
      method = if cache then 'loadData' else 'loadFromWeb'
      @window.send 'header:data', filters: data[1]
      @loader = new Loader(data[0], data[1])
      @loader[method]().then (results) =>
        @window.send 'sections:data', sections: data[0], offers: results

  filterResults: (sections, results, skip) ->
    _.map sections, (section, index) ->
      if skip["#{section.brand}-#{section.model}"]
        _.filter results, (result) ->
          _.contains skip["#{section.brand}-#{section.model}"], results.id
      else
        results

  clearStorage: ->
    Storage.clear().then ->
      console.log 'removed evetything'

app = new Application()
