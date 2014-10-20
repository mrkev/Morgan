'use strict';
var Crawler = require('./dir');

var user = {
  name: 'clmorgan', 
  dir: {
    path : process.env[(process.platform == 'win32') ? 'USERPROFILE' : 'HOME'] + '/Downloads',
    exclude_dirs  : ['node_modules', 'test', 'Old Desktop - Sep 4, 2014', 'Old Downloads', 'Shakeit'],
    exclude_files : ['.DS_Store']
  },
  port : 3110
};


var fc = new Crawler(user);
fc.crawl().then(function (files) {
  console.log(files);
  var sv = require('./staticserv')(user);
  sv.connect();
});


// Start, Connect and Re-connect ============================
// If no user secret, ask for username. Generate user secret.
// Start server. (On start)
// Send user name, user secret and IP to server.
// Recieve good to go. Officially sharing.

// Search Call ==============================================
// Go through files. Search for file. 
// Collect all file matches. 
// Send object on response.

// Do Search ================================================
// Go through files. Search for file. 
// Collect all file matches. 
// Send object on response.


// Generate user secret. 
// Post  