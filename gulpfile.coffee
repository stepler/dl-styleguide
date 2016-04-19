###
# Core modules
###

path = require "path"


###
# Gulp modules
###

gulp = require 'gulp'
sass = require 'gulp-sass'
watch = require 'gulp-watch'
cssmin = require 'gulp-cssmin'
plumber = require 'gulp-plumber'
runSequence = require 'run-sequence'
styleguide = require 'sc5-styleguide'
autoprefixer = require 'gulp-autoprefixer'


###
# Variables
###

R = __dirname
# pkg  = require "#{R}/package.json"
destPath = "#{R}/dest"
outputPath = "#{R}/output"
sourcePath = "#{R}/styles"
ServerStart = true


gulp.task 'styleguide:generate', ->

  gulp
  .src "#{sourcePath}/**/*.scss"
  .pipe plumber()
  .pipe styleguide.generate
    title: 'Skybonds styleguide'
    server: ServerStart
    rootPath: outputPath
    overviewPath: 'README.md'
  .pipe gulp.dest outputPath


gulp.task 'styleguide:applystyles', ->
  gulp
  .src "#{sourcePath}/styleguide.scss"
  .pipe plumber()
  .pipe sass()
  .pipe autoprefixer()
  .pipe cssmin()
  .pipe gulp.dest destPath
  .pipe styleguide.applyStyles()
  .pipe gulp.dest outputPath


gulp.task 'watch', ->
  ServerStart = false
  watch "#{sourcePath}/**/*.scss", ->
    gulp.start(
      'styleguide:generate'
      'styleguide:applystyles'
    )


gulp.task 'default', ->
  runSequence(
    'styleguide:generate'
    'styleguide:applystyles'
  )

