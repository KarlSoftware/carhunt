Backbone = require('backbone')

class Section extends Backbone.Model

  store: ->
    @collection.store()

module.exports = Section
