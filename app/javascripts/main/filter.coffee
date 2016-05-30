Q = require('q')
_ = require('underscore')
Storage = require('./storage')

class Filter
  @skip: (sections, results) ->
    deferred = Q.defer()
    Storage.getSkip().then (skip) =>
      filteredResults = @filter(sections, results, skip)
      deferred.resolve filteredResults
    deferred.promise

  @filter: (sections, results, skip) ->
    _.map sections, (section, index) ->
      if skip["#{section.brand}-#{section.model}"]
        _.reject results[index], (result) ->
          _.contains skip["#{section.brand}-#{section.model}"], result.id
      else
        results

module.exports = Filter
