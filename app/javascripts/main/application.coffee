electron = require('electron')
_ = require('underscore.string')

class Application

  events: [
    'ready', 'will-finish-launching', 'window-all-closed', 'before-quit',
    'will-quit', 'quit', 'open-file', 'open-url', 'activate', 'continue-activity',
    'browser-window-blur', 'browser-window-focus', 'browser-window-created',
    'certificate-error', 'select-client-certificate', 'login', 'gpu-process-crashed'
  ]

  constructor: ->
    @subscribeForEvent(event) for event in @events

  subscribeForEvent: (name) ->
    method = "on#{_.classify(name)}"
    electron.app.on name, =>
      @[method](arguments) if @[method]?

module.exports = Application
