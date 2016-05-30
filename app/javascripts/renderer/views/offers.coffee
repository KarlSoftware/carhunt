Marionette = require('backbone.marionette')
Offer = require('coffee!./offer.coffee')
EmptySection = require('coffee!./empty_section.coffee')

class Offers extends Marionette.CollectionView
  emptyView: EmptySection
  childView: Offer

  childViewOptions: ->
    currentBrand: @options.currentBrand
    currentModel: @options.currentModel

module.exports = Offers
