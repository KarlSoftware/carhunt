var Application = require('coffee!./otomoto.coffee');

var app = {}

require('electron').ipcRenderer.on('loaded' , function(event, data) {
  app = new Application(data);
});


require('electron').ipcRenderer.on('sections:data' , function(event, data) {
  app.renderSections(data);
});

require('electron').ipcRenderer.on('header:data' , function(event, data) {
  app.renderHeader(data);
});
