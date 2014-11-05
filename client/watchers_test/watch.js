

var watch = require('watch')
 watch.createMonitor('/Users/Kevin/Downloads', function (monitor) {
   monitor.on("created", function (f, stat) {
     console.log(f, 'created')
   })
   monitor.on("changed", function (f, curr, prev) {
    if (/.DS_Store/.test(f)) return;
     console.log(f, 'changed')
   })
   monitor.on("removed", function (f, stat) {
     console.log(f, 'removed')
   })
   // monitor.stop(); // Stop watching
 })

