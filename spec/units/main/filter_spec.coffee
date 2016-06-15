require('../../helper')
reload = require('require-reload')

describe 'Filter', =>
  Filter = {}
  sections = [
    {
      brand: 'bmw',
      model: 'seria3',
      offers: [
        { id: 12345, name: 'Broken car' },
        { id: 23456, name: 'Good car'}
      ]
    }, {
      brand: 'mercedes',
      model: 'cla',
      offers: [
        { id: 43210, name: 'Bad CLA 200' },
        { id: 54321, name: 'Good CLA 200' },
      ]
    }, {
      brand: 'audi',
      mode: 'r8',
      offers: [
        {id: 54323, name: 'Audi R8'},
        {id: 12323, name: 'Audi A4'},
      ]
    }
  ]
  describe '.skip', =>
    beforeEach =>
      data = { 'bmw-seria3': [12345], 'mercedes-cla': [43210] }
      mockRequire './../../../app/javascripts/main/storage',
        getSkip: => Promise.resolve(data)
      Filter = reload('./../../../app/javascripts/main/filter')

    it 'it should filter out skip options', =>
      Filter.skip(sections).then (results) =>
        expect(results).to.eql([
          {
            brand: 'bmw',
            model: 'seria3',
            offers: [{ id: 23456, name: 'Good car'}]
          }, {
            brand: 'mercedes',
            model: 'cla',
            offers: [{ id: 54321, name: 'Good CLA 200' }]
          }, {
            brand: 'audi',
            mode: 'r8',
            offers: [
              {id: 54323, name: 'Audi R8'},
              {id: 12323, name: 'Audi A4'},
            ]
          }
        ])
