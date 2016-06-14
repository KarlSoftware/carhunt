_ = require('underscore')
Q = require('q')
request = require('request')
Storage = require('./storage')
Document = require('./document')
Filter = require('./filter')

class Loader
  host: 'http://otomoto.pl'
  type: 'osobowe'
  maxPages: 1

  constructor: (@filters) ->

  loadSection: (section) ->
    deferred = Q.defer()
    @loadRecursive @buildUrl(section), [], deferred
    deferred.promise

  loadRecursive: (url, accumulator, deferred) ->
    console.log 'loading data from: ', url
    request url, (error, response, body) =>
      doc = new Document body
      accumulator.push doc
      if doc.hasNextPage() and accumulator.length < @maxPages
        @loadRecursive(doc.nextPageUrl(), accumulator, deferred)
      else
        items = accumulator.map (doc) -> doc.getItems()
        deferred.resolve _.flatten(items)
    deferred.promise

  buildUrl: (attrs) ->
    url = "#{@host}/#{@type}/#{attrs.brand}/#{attrs.model}/?#{@getFilters()}"

  getFilters: ->
    query = ''
    query += "search[filter_float_year%3Afrom]=#{@filters['year[from]']}" if @filters?['year[from]']
    query += "&search[filter_float_year%3Ato]=#{@filters['year[to]']}" if @filters?['year[to]']
    query += "&search[filter_float_mileage%3Afrom]=#{@filters['mileage[from]']}" if @filters?['mileage[from]']
    query += "&search[filter_float_mileage%3Ato]=#{@filters['mileage[to]']}" if @filters?['mileage[to]']
    query += "&search[filter_float_price%3Afrom]=#{@filters['price[from]']}" if @filters?['price[from]']
    query += "&search[filter_float_price%to]=#{@filters['price[to]']}" if @filters?['price[to]']
    query

module.exports = Loader
