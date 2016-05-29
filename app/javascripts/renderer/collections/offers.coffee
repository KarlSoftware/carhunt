_ = require('underscore')
Backbone = require('backbone')

class Offers extends Backbone.Collection

  comparator: (item) ->
    parseInt(item.get('price').replace(/\s+/g, ''))

  averagePrice: ->
    sum = 0
    @each (item) ->
      sum += parseInt(item.get('price').replace(/\s+/g, ''))
    Math.round sum/@length

  minPrice: ->
    Math.round _.min(@prices())

  maxPrice: ->
    Math.round _.max(@prices())

  prices: ->
    @map((item) ->
      parseInt(item.get('price').replace(/\s+/g, '')))

module.exports = Offers
