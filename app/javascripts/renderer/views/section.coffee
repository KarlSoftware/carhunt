$ = require('jquery')
Backbone = require('backbone')
Marionette = require('backbone.marionette')
Offers = require('coffee!./offers.coffee')

class Section extends Marionette.LayoutView

  getTemplate: => require('handlebars!./../templates/section.hbs')
  className: 'column'

  ui:
    brandSelect: '.js-brand-select'
    modelSelect: '.js-model-select'
    removeLink: '.js-remove'

  events:
    'change @ui.brandSelect': 'onChangeBrand'
    'change @ui.modelSelect': 'onChangeModel'
    'click @ui.removeLink': 'onClickRemove'

  regions:
    offersRegion: '.offers-region'

  initialize: ->
    @listenTo @model.collection, 'add', @adjustSection
    @listenTo @model.collection, 'remove', @adjustSection
    @brands = @options.brands
    if @model.get('brand')
      @models = @brands.findWhere(id: @model.get('brand')).relations
    else
      @models = new Backbone.Collection

  templateHelpers: ->
    brands: => @brands.toJSON()
    models: => @models.toJSON()
    averagePrice: =>
      @model.offers?.averagePrice()
    minPrice: =>
      @model.offers?.minPrice()
    maxPrice: =>
      @model.offers?.maxPrice()

  onChangeBrand: ->
    @updateBrandData()
    @render()

  onChangeModel: ->
    @updateModelData()
    @render()

  onClickRemove: ->
    @trigger 'section:remove'

  onRender: ->
    @adjustSection()
    @updateSelects()
    @renderOffers()

  updateSelects: ->
    @ui.brandSelect.val @model.get('brand')
    @ui.modelSelect.val @model.get('model')

  updateBrandData: ->
    @currentBrand = @brands.findWhere(id: @ui.brandSelect.val())
    @models.reset @currentBrand?.relations?.models
    @model.set brand: @currentBrand?.id, model: undefined
    @model.store()

  updateModelData: ->
    @currentModel = @models.findWhere(id: @ui.modelSelect.val())
    @model.set model: @currentModel?.id
    @model.store()

  renderOffers: ->
    @offersRegion.show new Offers
      collection: @model.offers

  adjustSection: =>
    @$el.css 'width', 100/@model.collection.length+'%'

module.exports = Section
