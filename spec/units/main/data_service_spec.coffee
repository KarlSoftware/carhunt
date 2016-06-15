require('../../helper')
reload = require('require-reload')

describe 'DataService', =>
  DataService = {}
  dataService = {}
  loadSectionSpy = {}
  setSectionSpy = {}

  mockLoaderData = (data) =>
    mockRequire './../../../app/javascripts/main/loader', =>
      loadSection: (=>
        if data
          loadSectionSpy = sinon.mock()
          loadSectionSpy.returns Promise.resolve(data)
        else
          loadSectionSpy = sinon.spy()
          loadSectionSpy
        )()

  mockStorageData = (data) =>
    setSectionSpy = sinon.mock()
    setSectionSpy.returns Promise.resolve()
    mockRequire './../../../app/javascripts/main/logger',
      log: => true
    mockRequire './../../../app/javascripts/main/storage',
      getSections: => Promise.resolve(data)
      setSections: setSectionSpy
    mockRequire './../../../app/javascripts/main/filter',
      skip: (data) => Promise.resolve(data)
    DataService = reload('./../../../app/javascripts/main/data_service')
    dataService = new DataService({})

  describe '#loadData', =>
    describe 'empty storage', =>
      beforeEach =>
        mockLoaderData()
        mockStorageData([])

      it 'should return empty array', =>
        dataService.loadData(false).then (results) =>
          expect(results).to.eql([])

      it 'should not call loader', =>
        dataService.loadData(false).then =>
          expect(loadSectionSpy.calledOnce).to.be.false

    describe 'sections exist in storage', =>
      describe 'single section without offers', =>
        beforeEach =>
          mockLoaderData([{id: '123', title: 'BMW seria 3 320d', price: '110000', url: 'http://otomolo.pl'}])
          mockStorageData([{ brand: 'bmw', model: 'seria3', offers: [] }])

        it 'should return loaded results', =>
          dataService.loadData().then (results) =>
            expect(results).to.eql([
              {
                brand: 'bmw',
                model: 'seria3',
                offers: [
                  {id: '123', title: 'BMW seria 3 320d', price: '110000', url: 'http://otomolo.pl'}
                ]
              }
            ])

      describe 'multiple sections with and without offers', =>
        beforeEach =>
          mockLoaderData([{id: '234', title: 'Mercedes CLA 200', price: '125000', url: 'http://otomolo.pl'}])
          mockStorageData([
            {
              brand: 'bmw',
              model: 'seria3',
              offers: [{ id: '123', title: 'BMW seria 3 320d', price: '110000', url: 'http://otomolo.pl' }]
            }, {
              brand: 'mercedes',
              model: 'cla',
              offers: []
            }
          ])

        it 'should return merged loaderd results and results from storage', =>
          dataService.loadData().then (results) =>
            expect(results).to.eql([
              {
                brand: 'bmw',
                model: 'seria3',
                offers: [{id: '123', title: 'BMW seria 3 320d', price: '110000', url: 'http://otomolo.pl'}]
              }, {
                brand: 'mercedes',
                model: 'cla',
                offers: [{id: '234', title: 'Mercedes CLA 200', price: '125000', url: 'http://otomolo.pl'}]
              }
            ])
            expect(loadSectionSpy.calledOnce).to.be.true
            expect(loadSectionSpy.args[0][0]).to.eql({
              brand: 'mercedes',
              model: 'cla',
              offers: []
            })

        it 'should store loaded data to storage', =>
          dataService.loadData().then (results) =>
            expect(setSectionSpy.calledOnce).to.be.true
            expect(setSectionSpy.args[0][0]).to.eql([
              {
                brand: 'bmw',
                model: 'seria3',
                offers: [{id: '123', title: 'BMW seria 3 320d', price: '110000', url: 'http://otomolo.pl'}]
              }, {
                brand: 'mercedes',
                model: 'cla',
                offers: [{id: '234', title: 'Mercedes CLA 200', price: '125000', url: 'http://otomolo.pl'}]
              }
            ])

      describe 'multiple sections with offers', =>
        beforeEach =>
          mockLoaderData()
          mockStorageData([
            {
              brand: 'bmw',
              model: 'seria3',
              offers: [{ id: '123', title: 'BMW seria 3 320d', price: '110000', url: 'http://otomolo.pl' }]
            }, {
              brand: 'mercedes',
              model: 'cla',
              offers: [{id: '234', title: 'Mercedes CLA 200', price: '125000', url: 'http://otomolo.pl'}]
            }
          ])

        it 'should return results from storage and not load data', =>
          dataService.loadData().then (results) =>
            expect(results).to.eql([
              {
                brand: 'bmw',
                model: 'seria3',
                offers: [{id: '123', title: 'BMW seria 3 320d', price: '110000', url: 'http://otomolo.pl'}]
              }, {
                brand: 'mercedes',
                model: 'cla',
                offers: [{id: '234', title: 'Mercedes CLA 200', price: '125000', url: 'http://otomolo.pl'}]
              }
            ])
            expect(loadSectionSpy.called).to.not.be.true
