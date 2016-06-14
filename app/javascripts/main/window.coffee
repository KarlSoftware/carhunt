path = require('path')
request = require('request')
electron = require('electron')
brands = require('./../data/brands.json')
models = require('./../data/models.json')
Document = require('./document')
json = require('../../package.json')

class Window

  constructor: (options) ->
    @onLoad = options.onLoad
    @createWindow()

  createWindow: ->
    @window = new electron.BrowserWindow
      title: json.name
      width: json.settings.width
      height: json.settings.height
      minWidth: json.settings.width
      minHeight: json.settings.height
    @window.loadURL 'file://' + path.join(__dirname, '..', '..') + '/index.html'
    @window.webContents.openDevTools(detach: true) if json.settings.devTools
    @window.webContents.executeJavaScript 'require("devtron").install()'
    @window.webContents.on 'did-finish-load', =>
      @window.webContents.send 'loaded', brands: brands, models: models
      @onLoad() if @onLoad?
    @window.on 'closed', =>
      @window = null

  send: (message, data = {}) ->
    @window.webContents.send message, data

module.exports = Window
