Q = require('q')
_ = require('lodash')
Storage = require('./storage')

class Filter
  @skip: (sections) ->
    deferred = Q.defer()
    Storage.getSkip().then (skip) =>
      @filter(sections, skip)
      deferred.resolve sections
    deferred.promise

  @filter: (sections, skip) ->
    sections.map (section, index) ->
      if skip["#{section.brand}-#{section.model}"]
        section.offers = _.remove section.offers, (result) ->
          skip["#{section.brand}-#{section.model}"].indexOf(result.id) == -1

module.exports = Filter
