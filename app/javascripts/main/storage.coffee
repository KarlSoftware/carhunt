Q = require('q')
_ = require('underscore')
json = require('../../package.json').settings
storage = require('electron-json-storage')


class Storage
  @getSections: ->
    get "#{json.namespace}:sections"

  @getFilters: ->
    get "#{json.namespace}:filters"

  @getOffers: ->
    get "#{json.namespace}:offers"

  @getSkip: ->
    get "#{json.namespace}:skip"

  @setSections: (data) ->
    set "#{json.namespace}:sections", data

  @setFilters: (data) ->
    set "#{json.namespace}:filters", data

  @setOffers: (data) ->
    set "#{json.namespace}:offers", data

  @setSkip: (data) ->
    deferred = Q.defer()
    @getSkip().done (skip) =>
      key = _.keys(data)[0]
      value = _.values(data)[0]
      if skip[key]
        skip[key].push value
      else
        skip[key] = [value]
      set("#{json.namespace}:skip", skip).done =>
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
    promises = _.map ["#{json.namespace}:sections", "#{json.namespace}:filters", "#{json.namespace}:offers", "#{json.namespace}:skip"], (key) ->
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
