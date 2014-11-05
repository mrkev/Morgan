watch = require "watch"
walk  = require "walk"


class FileManager

  file_db = {}

  ##
  # Sets up file watcher
  constructor : (path, ready) ->
    self = this
    console.log 'go over files and hash them'

    # Walker options
    walker = walk.walk(path,
      followLinks: false
    )

    walker.on "file", (root, stat, next) ->
      file_db[root + "/" + stat.name] = "#hash"
      next()

    walker.on "end", ->
      console.log "done hashing"
      if typeof ready is 'function'
        ready(self)

    watch.createMonitor path, (monitor) ->
      monitor.on "created", (f, stat) ->
        console.log f, "created"
        file_db[f] = '#hash'
        console.dir file_db

      monitor.on "changed", (f, curr, prev) ->
        return if /.DS_Store/.test(f)
        console.log f, "changed"

      monitor.on "removed", (f, stat) ->
        console.log f, "removed"
        delete file_db[f]
        console.dir file_db
  
  ##
  # Returns: All file paths (in file_db) matching query regexp.
  search_paths : (query) ->
    return Object.keys(file_db).filter (f) -> query.test(f)

module.exports = FileManager

# Test if main script #
if require.main is module
  fm = new FileManager '/Users/Kevin/Downloads/uTorrent', (fm) ->
    console.log(fm.search_paths /Color/)

