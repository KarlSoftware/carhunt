$ = require('jquery')
electron = require('electron')
Marionette = require('backbone.marionette')

class Offer extends Marionette.LayoutView

  getTemplate: => require('handlebars!./../templates/offer.hbs')
  className: 'offer row'

  ui:
    link: '.js-link'
    skip: '.js-skip-offer'

  events:
    'click @ui.link': 'onClickLink'
    'click @ui.skip': 'onClickSkip'

  onClickLink: (e) ->
    e.preventDefault()
    electron.shell.openExternal $(e.currentTarget).attr('href')

  onClickSkip: ->
    params = {}
    params["#{@options.currentBrand}-#{@options.currentModel}"] = @model.id
    electron.ipcRenderer.send 'skip:change', params

module.exports = Offer
