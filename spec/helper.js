var path = require('path');
global.expect = require('chai').expect
global.assert = require('chai').assert
global.sinon = require('sinon')
global.mockRequire = require('mock-require')

afterEach(function () {
  mockRequire.stopAll();
});

module.exports = {
  appPath: function() {
    switch (process.platform) {
      case 'darwin':
        return path.join(__dirname, '..', '.tmp', "Otomoto-" + process.platform + "-" + process.arch, 'Otomoto.app', 'Contents', 'MacOS', 'Otomoto');
      case 'linux':
        return path.join(__dirname, '..', '.tmp', "Otomoto-" + process.platform + "-" + process.arch, 'Otomoto');
      default:
        throw 'Unsupported platform';
    }
  }
};
