fs       = require 'fs-extra'
home_dir = process.env[if process.platform is 'win32' then 'USERPROFILE' else 'HOME']
path     = home_dir + '/.morganrc.json'



###
user {
    name: <string>
    token: <string>
}

directories: [
    {
        path: <string>
        exclude_dirs: <string>
        exclude_files: <string>
    }
]


###

module.exports = (-> 

    rcfile =  # Open the rc file's preferences
        try 
            require path
        catch 
            fs.outputFileSync path, '{}'
            require path

    Preferences = () ->

    Preferences::save = -> 
        console.log 'will save preferences'

    Preferences::load = (rcfile) ->
        @user = rcfile.user ? null
        @directories = rcfile.directories ? []

    return new Preferences()
)()


###

Preferences::defaultDir = home_dir + "/Downloads"

preferences.directory = {
  path: process.env[(if (process.platform is "win32") then "USERPROFILE" else "HOME")] + "/Downloads"
  exclude_dirs: [
    "node_modules"
    "test"
    "Old Desktop - Sep 4, 2014"
    "Old Downloads"
    "Shakeit"
  ]
  exclude_files: [".DS_Store"]
}
###