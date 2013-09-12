fs = require 'fs'
{exec} = require 'child_process'
util = require 'util'

environments = require './ENVIRONMENTS'

coffeeSrcDir = 'src/coffee'
jsTargetDir = 'build/js'
lessSrcDir = 'src/less'
cssTargetDir = 'build/css'
htmlMainFile = 'src/main.html'
jsMainFile = 'src/main.js'
versionFile = 'VERSION'

coffeeFiles = [
  {'infile': 'application.coffee', 'outdir': ''},

  {'infile': 'factories/TGPaginatedResource.coffee', 'outdir': 'factories'},
  {'infile': 'factories/unauthorizedInterceptor.coffee', 'outdir': 'factories'},

  {'infile': 'providers/TGResourceProvider.coffee', 'outdir': 'providers'},
  {'infile': 'providers/currentUserProvider.coffee', 'outdir': 'providers'},

  {'infile': 'controllers/PageController.coffee', 'outdir': 'controllers'},
  {'infile': 'controllers/TopBarController.coffee', 'outdir': 'controllers'},
  {'infile': 'controllers/QuestionListController.coffee', 'outdir': 'controllers'},
  {'infile': 'controllers/QuestionController.coffee', 'outdir': 'controllers'},
  {'infile': 'controllers/ProfileController.coffee', 'outdir': 'controllers'},
  {'infile': 'controllers/CityKnowledgeController.coffee', 'outdir': 'controllers'},
  {'infile': 'controllers/ForbiddenController.coffee', 'outdir': 'controllers'},
  {'infile': 'controllers/LoginController.coffee', 'outdir': 'controllers'},
]

lessMain = 'styles.less'
cssMain = 'styles.css'

task 'clean', "Clean the build folder", () ->
  util.log("Cleaning...")
  exec "rm -r build", (err, stdio, stderr) ->
  exec "mkdir build", (err, stdio, stderr) ->
  exec "mkdir #{jsTargetDir}", (err, stdio, stderr) ->
  for file in coffeeFiles then do (file) ->
    exec "mkdir #{jsTargetDir}/#{file.outdir}", (err, stdio, stderr) ->
  exec "mkdir #{cssTargetDir}", (err, stdio, stderr) ->
  exec "mkdir dist", (err, stdio, stderr) ->

task 'build', "Build app", () ->
  invoke 'clean'
  if not (process.env["TGENV"] in ["production", "development"])
    util.log "Please set TGENV environment variable to `production` or `development`"
    return
  util.log "BUILD FOR: #{process.env["TGENV"]}"
  util.log "Compiling coffee-script"
  for file in coffeeFiles then do (file) ->
    cmd = "coffee -c -o #{jsTargetDir}/#{file.outdir} #{coffeeSrcDir}/#{file.infile}"
    util.log "#{coffeeSrcDir}/#{file.infile} -> #{jsTargetDir}/#{file.outdir}"
    exec cmd, (err, stdio, stderr) ->
      if err
        util.log stdio
        util.log stderr
  util.log "Compiling less"
  cmd = "lessc #{lessSrcDir}/#{lessMain} #{cssTargetDir}/#{cssMain}"
  exec cmd, (err, stdio, stderr) ->
    if err
      util.log stdio
      util.log stderr
  util.log "templates -> templates"
  exec "cp -r src/templates build/templates", (err, stdout, stderr) ->
  util.log "assets -> assets"
  exec "cp -r src/assets build/assets", (err, stdout, stderr) ->
  util.log "main.js -> build/js/main.js"
  exec "cp src/main.js build/js/main.js", (err, stdout, stderr) ->
  util.log "main.html -> index.html"
  exec "cp src/main.html build/index.html", (err, stdout, stderr) ->
  util.log "Replacing ENVIRONMENT variables"
  for key, value of environments[process.env.TGENV]
       util.log "***#{key}*** -> #{value}"
       cmd = "find build/ -type f | xargs -0 | ./env_replace #{key} #{value}"
       exec cmd, (err, stdio, stderr) ->

task 'version', "Version a distribution", () ->
  version = environments[process.env.TGENV].version
  util.log "VERSIONING... (#{version})"
  exec "mkdir build/#{version}"
  exec "mv build/js build/#{version}/"
  exec "mv build/css build/#{version}/"
  exec "mv build/templates build/#{version}/"
  exec "mv build/assets build/#{version}/"
  exec "cd build && ln -s ../bower_components bower_components"

task 'package', "", () ->
  version = environments[process.env.TGENV].version
  name = "towngeek-web-#{version}-#{process.env.TGENV}"
  cmd = "cd dist && cp -r ../build #{name} && rm #{name}/bower_components && cp ../bower.json #{name}/bower.json && tar -zcvf #{name}.tar.gz #{name} && rm -r #{name}"
  exec cmd
