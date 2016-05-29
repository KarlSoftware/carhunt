_ = require('underscore')
$ = require('jquery')
Backbone = require('backbone')
Filter = require('coffee!./models/filter.coffee')
Sections = require('coffee!./collections/sections.coffee')
Offers = require('coffee!./collections/offers.coffee')
Layout = require('coffee!./views/layout.coffee')

class Application

  constructor: (data) ->
    @layout = new Layout
      el: $('#main')
      brands: @setupBrandsModelsData(data)
    @layout.render()

  renderHeader: (data) ->
    @layout.renderHeader new Filter data.filters

  renderSections: (data) ->
    @layout.renderSections @setupSectionsOffersData data

  setupBrandsModelsData: (data) ->
    brands = new Backbone.Collection _.filter data.brands, (brand) =>
      _.contains _.keys(data.models), brand.id
    brands.each (brand) =>
      brand.relations = new Backbone.Collection data.models[brand.id]
    brands

  setupSectionsOffersData: (data) ->
    sections = new Sections data.sections
    if sections.length is 0
      sections.add {}
    else
      sections.each (section, index) =>
        section.offers = new Offers data.offers[index]
    sections


module.exports = Application
