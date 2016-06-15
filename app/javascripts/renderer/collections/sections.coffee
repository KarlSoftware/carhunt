_ = require('underscore')
electron = require('electron')
Backbone = require('backbone')
Section = require('coffee!./../models/section.coffee')

class Sections extends Backbone.Collection

  model: Section

  store: ->
    electron.ipcRenderer.send 'sections:change', @toJSON()

module.exports = Sections
