require('../../helper')
reload = require('require-reload')

describe 'Loader', =>
  beforeEach =>
    mockRequire 'request', (url, callback) =>
      callback(null, {}, '')
    mockRequire './../../../app/javascripts/main/filter', {}
    mockRequire './../../../app/javascripts/main/storage', {}

  describe '#loadSection', =>
    describe 'No filters provided', =>
      describe 'Single page results', =>
        beforeEach =>
          mockRequire './../../../app/javascripts/main/document', =>
            getItems: => [
              { id: '123', title: 'BMW seria 3 320d', price: '110000', url: 'http://otomolo.pl' },
              { id: '234', title: 'BMW seria 3 xDrive', price: '150000', url: 'http://otomolo.pl' }
            ]
            hasNextPage: => false

          Loader = reload('./../../../app/javascripts/main/loader')
          @loader = new Loader({})

        it 'should return loaded offers', =>
          @loader.loadSection({brand: 'bmw', model: 'seria3'}).then (offers) =>
            expect(offers).to.eql([
              {id: '123', title: 'BMW seria 3 320d', price: '110000', url: 'http://otomolo.pl'},
              { id: '234', title: 'BMW seria 3 xDrive', price: '150000', url: 'http://otomolo.pl' }
            ])

      describe 'Multi-page results', =>
        beforeEach =>
          mockRequire './../../../app/javascripts/main/document', =>
            getItems: => [
              { id: '123', title: 'BMW seria 3 320d', price: '110000', url: 'http://otomolo.pl' },
              { id: '234', title: 'BMW seria 3 xDrive', price: '150000', url: 'http://otomolo.pl' }
            ]
            hasNextPage: => true
            nextPageUrl: => 'http://otomoto.pl/osobowe/bmw/seria3/?page=2'

          Loader = reload('./../../../app/javascripts/main/loader')
          @loader = new Loader({})
          @loader.maxPages = 2

        it 'should return loaded offers', =>
          @loader.loadSection({brand: 'bmw', model: 'seria3'}).then (offers) =>
            expect(offers).to.eql([
              {id: '123', title: 'BMW seria 3 320d', price: '110000', url: 'http://otomolo.pl'},
              { id: '234', title: 'BMW seria 3 xDrive', price: '150000', url: 'http://otomolo.pl' },
              {id: '123', title: 'BMW seria 3 320d', price: '110000', url: 'http://otomolo.pl'},
              { id: '234', title: 'BMW seria 3 xDrive', price: '150000', url: 'http://otomolo.pl' }
            ])

    describe 'With filters provided', =>
      beforeEach =>
        @requestSpy = sinon.mock().returns(Promise.resolve(1))
        mockRequire './../../../app/javascripts/main/document', =>
          getItems: => []
          hasNextPage: => false

        Loader = reload('./../../../app/javascripts/main/loader')
        @loader = new Loader({
          'year[from]': 2013,
          'year[to]': 2016,
          'mileage[from]': 10000,
          'mileage[to]': 11000,
          'price[from]': 55000,
          'price[to]': 100000
        })

      it 'should build correct url', =>

        @loader.loadRecursive = (url, accumulator, deferred) =>
          deferred.resolve(url)

        @loader.loadSection({brand: 'bmw', model: 'seria3'}).then (url) =>
          expect(url).to.eq('http://otomoto.pl/osobowe/bmw/seria3/?search[filter_float_year%3Afrom]=2013&search[filter_float_year%3Ato]=2016&search[filter_float_mileage%3Afrom]=10000&search[filter_float_mileage%3Ato]=11000&search[filter_float_price%3Afrom]=55000&search[filter_float_price%to]=100000')
