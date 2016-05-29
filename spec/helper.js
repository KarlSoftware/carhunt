var path = require('path');

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
