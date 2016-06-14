_ = require('underscore')
electron = require('electron')
Backbone = require('backbone')
Section = require('coffee!./../models/section.coffee')

class Sections extends Backbone.Collection

  model: Section

  store: ->
    # electron.ipcRenderer.send 'offers:change', @getOffersData()
    electron.ipcRenderer.send 'sections:change', @toJSON()

  getOffersData: ->
    offers = @map (item) =>
      if item.offers?
        item.offers.toJSON()
      else
        null
    _.compact(offers)

module.exports = Sections
