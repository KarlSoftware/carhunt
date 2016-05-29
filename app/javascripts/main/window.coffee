path = require('path')
request = require('request')
electron = require('electron')
brands = require('./../data/brands.json')
models = require('./../data/models.json')
Document = require('./document')

class Window

  constructor: (data) ->
    @createWindow(data)

  createWindow: (data) ->
    @window = new electron.BrowserWindow
      title: data.name
      width: data.settings.width
      height: data.settings.height
      minWidth: data.settings.width
      minHeight: data.settings.height
    @window.loadURL 'file://' + path.join(__dirname, '..', '..') + '/index.html'
    @window.webContents.openDevTools(detach: true) if data.settings.devTools
    @window.webContents.executeJavaScript 'require("devtron").install()'
    @window.webContents.on 'did-finish-load', =>
      @window.webContents.send 'loaded', brands: brands, models: models
      @onLoad() if @onLoad?
    @window.on 'closed', =>
      @window = null

  send: (message, data = {}) ->
    @window.webContents.send message, data

module.exports = Window
