require('../../helper')
reload = require('require-reload')

describe 'Storage', =>
  @getSpy = sinon.spy()
  @setSpy = sinon.spy()
  @removeSpy = sinon.spy()

  @mock =
    get: @getSpy
    set: @setSpy
    remove: @removeSpy

  mockRequire 'electron-json-storage', @mock

  Storage = require('./../../../app/javascripts/main/storage')

  mockStorageData = (data) =>
    mockRequire.stopAll()
    @setSkipSpy = sinon.spy()

    mockRequire 'electron-json-storage',
      get: (key, callback) => callback(null, data)
      set: @setSkipSpy
    Storage = reload('./../../../app/javascripts/main/storage')
    
  describe '#getSections', =>
    beforeEach (done) =>
      Storage.getSections()
      done()

    it 'should call get Otomoto:sections on electron-json-storage', =>
      assert(@getSpy.calledWith('Otomoto:sections'))

  describe '#getFilters', =>
    beforeEach (done) =>
      Storage.getFilters()
      done()

    it 'should call get Otomoto:filters on electron-json-storage', =>
      assert(@getSpy.calledWith('Otomoto:filters'))

  describe '#getOffers', =>
    beforeEach (done) =>
      Storage.getOffers()
      done()

    it 'should call get Otomoto:offers on electron-json-storage', =>
      assert(@getSpy.calledWith('Otomoto:offers'))

  describe '#getSkip', =>
    beforeEach (done) =>
      Storage.getSkip()
      done()

    it 'should call get Otomoto:skip on electron-json-storage', =>
      assert(@getSpy.calledWith('Otomoto:skip'))

  describe '#getSkip', =>
    beforeEach (done) =>
      Storage.getSkip()
      done()

    it 'should call get Otomoto:skip on electron-json-storage', =>
      assert(@getSpy.calledWith('Otomoto:skip'))

  describe '#setSections', =>
    beforeEach (done) =>
      Storage.setSections [
        { brand: 'bmw', model: 'seria3', offers: [] },
        { brand: 'mercedes', model: 'cla', offers: [] }
      ]
      done()

    it 'should call set Otomoto:sections on electron-json-storage', =>
      assert(@setSpy.calledWith('Otomoto:sections', [
        { brand: 'bmw', model: 'seria3', offers: [] },
        { brand: 'mercedes', model: 'cla', offers: [] }
      ]))

  describe '#setFilters', =>
    beforeEach (done) =>
      Storage.setFilters {
        'year[from]': 2010,
        'year[to]': 2016
      }
      done()

    it 'should call set Otomoto:filters on electron-json-storage', =>
      assert(@setSpy.calledWith('Otomoto:filters', {
        'year[from]': 2010,
        'year[to]': 2016
      }))

  describe '#setOffers', =>
    beforeEach (done) =>
      Storage.setOffers [12345, 23456]
      done()

    it 'should call set Otomoto:offers on electron-json-storage', =>
      assert(@setSpy.calledWith('Otomoto:offers', [12345, 23456]))

  describe '#clear', =>
    beforeEach (done) =>
      Storage.clear()
      done()

    it 'should remove all otomoto keys', =>
      expect(@removeSpy.getCall(0).args[0]).to.eql('Otomoto:sections')
      expect(@removeSpy.getCall(1).args[0]).to.eql('Otomoto:filters')
      expect(@removeSpy.getCall(2).args[0]).to.eql('Otomoto:offers')
      expect(@removeSpy.getCall(3).args[0]).to.eql('Otomoto:skip')

  describe '#setSkip', =>
    describe 'Skiped models present', =>
      beforeEach (done) =>
        mockStorageData({ bmw: [54321], mercedes: [23456] })
        Storage.setSkip(bmw: 12345)
        setTimeout(done, 0)

      it 'should call set Otomoto:skip on electron-json-storage', =>
        expect(@setSkipSpy.getCall(0).args[0]).to.eql('Otomoto:skip')
        expect(@setSkipSpy.getCall(0).args[1]).to.eql({ bmw: [ 54321, 12345], mercedes: [23456] })

    describe 'No skiped models', =>
      beforeEach (done) =>
        mockStorageData({ })
        Storage.setSkip(bmw: 12345)
        setTimeout(done, 0)

      it 'should call set Otomoto:skip on electron-json-storage', =>
        expect(@setSkipSpy.getCall(0).args[0]).to.eql('Otomoto:skip')
        expect(@setSkipSpy.getCall(0).args[1]).to.eql({ bmw: [12345] })
