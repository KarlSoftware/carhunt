cheerio = require('cheerio')

class Document

  constructor: (body) ->
    @$ = cheerio.load body

  hasNextPage: ->
    @nextPage().length isnt 0

  nextPageUrl: ->
    @nextPage().prop('href')

  getItems: ->
    items = []
    @$('article.list-offer-item').map (i, item) =>
      items.push
        id: @$(item).find('.om-title a').prop('data-ad-id')
        title: @$(item).find('.om-title').text().trim()
        price: @$(item).find('.om-price').text()
        price_desc: @$(item).find('.params-small').text().replace(/\s+/g, '')
        image: @$(item).find('.photo-box a').prop('style')['background-image'].substring(5).slice(0,-2)
        url: @$(item).find('.om-title a').prop('href')
        params_list: @getParams(item)
    items

  getParams: (item)->
    items = []
    @$(item).find('.om-params-list li').map (i, param) =>
      items.push @$(param).find('span').text()
    items.join(' <small>&middot;</small> ')

  nextPage: ->
    @$('.om-pager li.next a')

module.exports = Document
