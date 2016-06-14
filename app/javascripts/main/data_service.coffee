Q = require('q')
_ = require('lodash')
Storage = require('./storage')
Loader = require('./loader')

class DataService

  constructor: (@filters) ->
    @loader = new Loader(@filters)

  loadData: ->
    deferred = Q.defer()
    Storage.getSections().then (sections) =>
      console.log 'Sections: ', sections
      promises = _.map sections, (section) => @buildPromise(section)
      Q.all(promises).catch((e) => console.log(e)).then (sections) =>
        Storage.setSections(sections).then =>
          deferred.resolve(sections)
    deferred.promise

  buildPromise: (section) ->
    deferred = Q.defer()
    if !section.offers? || section.offers.length is 0
      @loader.loadSection(section).then (results) =>
        deferred.resolve _.merge(offers: results, section)
    else
      deferred.resolve(section)
    deferred.promise


module.exports = DataService
