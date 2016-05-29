Marionette = require('backbone.marionette')

class EmptySection extends Marionette.ItemView

  getTemplate: -> require('handlebars!./../templates/empty_section.hbs')
  className: 'emptystate'

module.exports = EmptySection
