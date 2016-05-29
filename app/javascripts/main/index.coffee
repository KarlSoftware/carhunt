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
    @window = new Window(json)
    @loader = new Loader()
    @bindEvents()
    @window.onLoad = @fetchData

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

  fetchData: =>
    Q.all([Storage.getSections(), Storage.getFilters(), Storage.getOffers()]).then (data) =>
      console.log "Fetch stored sections: ", data[0]
      console.log "Fetch stored filters: ", data[1]
      @window.send 'header:data', filters: data[1]
      if data[2].length
        @window.send 'sections:data', sections: data[0], offers: data[2]
      else
        @loader.loadData(data[0], data[1]).then (results) =>
          Storage.setOffers(results).then =>
            @window.send 'sections:data', sections: data[0], offers: results

  loadData: (sections, filters) ->
    Q.all([Storage.getSections(), Storage.getFilters()]).then (data) =>
      console.log "Fetch stored sections: ", data[0]
      console.log "Fetch stored filters: ", data[1]
      @loader.loadData(data[0], data[1]).then (results) =>
        console.log "Updating local cache.."
        Storage.setOffers(results).done =>
          console.log "Refresh data"
          @window.send 'sections:data', sections: data[0], offers: results
        .fail (err) => console.log err

  clearStorage: ->
    Storage.clear().then ->
      console.log 'removed evetything'

app = new Application()
