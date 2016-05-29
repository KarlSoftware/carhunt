Q = require('q')
_ = require('underscore')
json = require('../../package.json')
storage = require('electron-json-storage')

class Storage
  @getSections: ->
    get "#{json.namespace}:sections"

  @getFilters: ->
    get "#{json.namespace}:filters"

  @getOffers: ->
    get "#{json.namespace}:offers"

  @setSections: (data) ->
    set "#{json.namespace}:sections", data

  @setFilters: (data) ->
    set "#{json.namespace}:filters", data

  @setOffers: (data) ->
    set "#{json.namespace}:offers", data

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
    promises = _.map ["#{json.namespace}:sections",  "#{json.namespace}:filters"], (key) ->
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
