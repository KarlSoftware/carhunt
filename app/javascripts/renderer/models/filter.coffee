electron = require('electron')
Backbone = require('backbone')

class Filter extends Backbone.Model

  store: ->
    electron.ipcRenderer.send 'filters:change', @attributes

module.exports = Filter
