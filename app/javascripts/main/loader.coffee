_ = require('underscore')
Q = require('q')
request = require('request')
Storage = require('./storage')
Document = require('./document')

class Loader
  host: 'http://otomoto.pl'
  type: 'osobowe'
  maxPages: 1

  constructor: (@sections, @filters) ->

  loadData: ->
    deferred = Q.defer()
    @loadFromCache().then (data) ->
      deferred.resolve(data)
    , (error) =>
      @loadFromWeb().done (data) ->
        deferred.resolve(data)
    deferred.promise

  loadFromCache: ->
    deferred = Q.defer()
    Storage.getOffers().then (results) =>
      if results?.length > 1  and !_.isEmpty(results[0])
        deferred.resolve(results)
      else
        deferred.reject('empty cache')
    deferred.promise

  loadFromWeb: ->
    deferred = Q.defer()
    promises = _.map @sections, (section) =>
      @buildPromise(section)
    Q.all(promises).then (results) =>
      if results.length > 1
        @saveCache(results, deferred)
      else
        deferred.resolve(results)
    , (error) ->
      deferred.reject('connection error')
    deferred.promise

  saveCache: (results, deferred) ->
    Storage.setOffers(results).then ->
      deferred.resolve(results)
    , (error) ->
      console.log('Failed to save cache', error)
      deferred.resolve(results)

  buildPromise: (section) ->
    deferred = Q.defer()
    if section.brand? and section.model?
      @loadRecursive @buildUrl(section), [], deferred
    else
      deferred.resolve([])

  loadRecursive: (url, accumulator, deferred) ->
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
    console.log "Fetching data from #{url}"
    url

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
