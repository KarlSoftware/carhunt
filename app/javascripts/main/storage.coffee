Q = require('q')
_ = require('underscore')
storage = require('electron-json-storage')

class Storage
  @getSections: ->
    get "Otomoto:sections"

  @getFilters: ->
    get "Otomoto:filters"

  @getOffers: ->
    get "Otomoto:offers"

  @getSkip: ->
    get "Otomoto:skip"

  @setSections: (data) ->
    set "Otomoto:sections", data

  @setFilters: (data) ->
    set "Otomoto:filters", data

  @setOffers: (data) ->
    set "Otomoto:offers", data

  @setSkip: (data) ->
    deferred = Q.defer()
    @getSkip().then (skip) =>
      key = _.keys(data)[0]
      value = _.values(data)[0]
      if skip[key]
        skip[key].push value
      else
        skip[key] = [value]
      set("Otomoto:skip", skip).done =>
        deferred.resolve()
    deferred.promise

  @clear: ->
    remove()

  set = (key, value) ->
    deferred = Q.defer()
    storage.set key, value, (error) ->
      if error
        deferred.reject()
      else
        deferred.resolve()
    deferred.promise

  get = (key) ->
    deferred = Q.defer()
    storage.get key, (error, data) =>
      if error
        deferred.reject()
      else
        deferred.resolve(data)
    deferred.promise

  remove = ->
    promises = _.map ["Otomoto:sections", "Otomoto:filters", "Otomoto:offers", "Otomoto:skip"], (key) ->
      buildRemovePromise(key)
    Q.all(promises)

  buildRemovePromise = (key) ->
    deferred = Q.defer()
    storage.remove key, (error) ->
      if error
        deferred.reject()
      else
        deferred.resolve()
    deferred.promise



module.exports = Storage
