require('../../helper')
reload = require('require-reload')

describe 'Application', =>

  beforeEach =>
    @sendSpy = sinon.spy()
    @ipcMainSpy = sinon.spy()

    mockRequire 'electron',
      app:
        on: =>
      ipcMain:
        on: @ipcMainSpy

    mockRequire './../../../app/javascripts/main/window', (options) =>
      options.onLoad()
      send: @sendSpy

    mockRequire './../../../app/javascripts/main/storage',
      getFilters: => Promise.resolve({})

    mockRequire './../../../app/javascripts/main/data_service', =>
      loadData: => Promise.resolve(
        [
          {
            brand: 'bmw',
            model: 'seria3',
            offers: [{id: '123', title: 'BMW seria 3 320d', price: '110000', url: 'http://otomolo.pl'}]
          }, {
            brand: 'mercedes',
            model: 'cla',
            offers: [{id: '234', title: 'Mercedes CLA 200', price: '125000', url: 'http://otomolo.pl'}]
          }
        ]
      )

    @app = reload('../../../app/javascripts/main/index')
    @app.onReady()

  describe 'onReady', =>
    it 'should bind all app messages', =>
      expect(@ipcMainSpy.callCount).to.eq(5)
      expect(@ipcMainSpy.getCall(0).args[0]).to.eq('filters:change')
      expect(@ipcMainSpy.getCall(1).args[0]).to.eq('sections:change')
      expect(@ipcMainSpy.getCall(2).args[0]).to.eq('offers:change')
      expect(@ipcMainSpy.getCall(3).args[0]).to.eq('data:load')
      expect(@ipcMainSpy.getCall(4).args[0]).to.eq('skip:change')

    it 'should send filters to window', =>
      expect(@sendSpy.calledWith('header:data', filters: {})).to.be.true

    it 'should send sections data to window', =>
      expect(@sendSpy.lastCall.args[0]).to.eq('sections:data')
      expect(@sendSpy.lastCall.args[1]).to.eql(
        {
          sections: [
            {
              brand: 'bmw',
              model: 'seria3',
              offers: [{id: '123', title: 'BMW seria 3 320d', price: '110000', url: 'http://otomolo.pl'}]
            }, {
              brand: 'mercedes',
              model: 'cla',
              offers: [{id: '234', title: 'Mercedes CLA 200', price: '125000', url: 'http://otomolo.pl'}]
            }
          ]
        }
      )
