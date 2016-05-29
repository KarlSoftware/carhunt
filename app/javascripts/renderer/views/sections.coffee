Marionette = require('backbone.marionette')
Section = require('coffee!./section.coffee')

class Sections extends Marionette.CompositeView
  maxSectionCount: 4

  getTemplate: -> require('handlebars!../templates/sections.hbs')
  childView: Section
  className: 'lists'
  childViewContainer: '.js-sections-list'

  childViewOptions: ->
    brands: @options.brands

  childEvents: ->
    'section:remove': 'onRemoveSection'

  ui:
    addSection: '.js-add-section'

  events:
    'click @ui.addSection': 'onClickAddSection'

  onRender: ->
    @updateControls()

  onClickAddSection: ->
    @collection.add {} unless @collection.length is @maxSectionCount
    @updateControls()

  onRemoveSection: (view) ->
    @collection.remove view.model
    @collection.store()
    @collection.add {} if @collection.length is 0
    @updateControls()

  updateControls: ->
    if @collection.length is @maxSectionCount
      @$el.addClass('full')
      @ui.addSection.hide()
    else
      @$el.removeClass('full')
      @ui.addSection.show()

module.exports = Sections
