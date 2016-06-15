$ = require('jquery')
Backbone = require('backbone')
Marionette = require('backbone.marionette')
Header = require('coffee!./header.coffee')
Sections = require('coffee!./sections.coffee')

class Layout extends Marionette.LayoutView

  getTemplate: => require('handlebars!./../templates/layout.hbs')

  regions:
    headerRegion: '#header'
    bodyRegion: '#body'

  onRender: ->
    @adjustHeight()
    $(window).on 'resize', => @adjustHeight()

  renderSections: (sections) ->
    @bodyRegion.show new Sections
      brands: @options.brands
      collection: sections

  renderHeader: (filters) ->
    @header = new Header filters: filters
    @headerRegion.show @header

  adjustHeight: ->
    $('#body').height($(window).height() - 47)

module.exports = Layout
