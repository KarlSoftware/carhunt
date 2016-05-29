$ = require('jquery')
electron = require('electron')
Marionette = require('backbone.marionette')

class Offer extends Marionette.LayoutView

  getTemplate: => require('handlebars!./../templates/offer.hbs')
  className: 'offer row'

  ui:
    link: '.js-link'

  events:
    'click @ui.link': 'onClickLink'

  onClickLink: (e) ->
    e.preventDefault()
    electron.shell.openExternal $(e.currentTarget).attr('href')

module.exports = Offer
