'use strict';
var dir = require('node-dir');
var sha = require('sha');
var Promise = require('es6-promise').Promise;


module.exports = (function () {

  var user_id;
  var user_dir;
  
  function FileCrawler (user) {
    this.results = [];
    this.errors  = [];
    this.fin_err = [];
    user_id = user.name + ':';
    user_dir = user.dir;
  }

  /**
   * Crawls all directories, and resolves with an object containing all file
   * objects representing the user's shared files.
   * @return {Promise} Resolves with files object.
   */
  FileCrawler.prototype.crawl = function() {
    var self = this;

    return new Promise(function (resolve) {
      resolve([]);
    });

    /* 
    return new Promise(function (resolve) {

      dir
        .readFiles(user_dir.path, { excludeDir:user_dir.exclude_dirs }, 
          
          // File. 
          function(err, content, filename, next) {
              
              if (err) { throw err; }

              sha.get(filename, function (err, sha1) {
                self.results.push({'name'  : filename.replace(user_dir, user_id), 
                              'hash'  : sha1,
                              'type'  : 'unkown'});

                console.log(filename);
                next();
              });
          },

          // End
          function(err, files){
            if (err) { throw err; }

            console.log(self.results);

            console.log(files.length);

            resolve(self.results);

            // console.log('finished reading files:',files.length);
          });  
    });*/
  };

  return FileCrawler;
})();



