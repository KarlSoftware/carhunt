Q = require('q')
_ = require('lodash')
Storage = require('./storage')
logger = require('./logger')
Loader = require('./loader')
Filter = require('./filter')

class DataService

  constructor: (@filters) ->
    @loader = new Loader(@filters)

  loadData: (@force) ->
    deferred = Q.defer()
    Storage.getSections().then (sections) =>
      logger.log "Got #{sections.length} sections"
      promises = _.map sections, (section) => @buildPromise(section)
      Q.all(promises).catch((e) => console.log(e)).then (results) =>
        Filter.skip(results).then (sections) =>
          Storage.setSections(sections).then =>
            logger.log 'Update data in local storage'
            deferred.resolve(sections)
    deferred.promise

  buildPromise: (section) ->
    deferred = Q.defer()
    if !section.offers? || section.offers.length is 0 || @force
      @loader.loadSection(section).then (results) =>
        result = _.clone section
        result.offers = results
        deferred.resolve result
    else
      deferred.resolve(section)
    deferred.promise


module.exports = DataService
