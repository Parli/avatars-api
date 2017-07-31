_ = require('underscore')
Identicon = require('identicon.js')
md5 = require('md5')
router = require('express').Router()
common = require('./common.coffee')
imageMagick = require('gm').subClass({imageMagick: true})

defaultSize = 400

identiconOptions =
  margin: 0.22
  background: [255, 255, 255, 255]
  saturation: 0.8
  brightness: 0.4

mkIdenticon = (id, size) ->
  parsed = parseInt size
  opts = _.extend identiconOptions,
    size: if Number.isInteger(parsed) then parsed else defaultSize
  identicon = new Identicon(md5(id), opts).toString()
  return new Buffer(identicon, 'base64')

unfuck = (buffer, callback) ->
  imageMagick(buffer, 'identicon.png')
    .stream('png', callback)

etagPrefix = 'parli-identicon-v1'

router.get '/:id', (req, res, next) ->
  res.set 'ETag': "#{etagPrefix}|#{req.params.id}"
  unfuck mkIdenticon(req.params.id), (err, stdout) ->
    common.sendImage(err, stdout, req, res, next)

# with custom size
router.get '/:size/:id', (req, res, next) ->
  res.set 'ETag': "#{etagPrefix}|#{req.params.id}"
  unfuck mkIdenticon(req.params.id, req.params.size), (err, stdout) ->
    common.sendImage(err, stdout, req, res, next)

module.exports = router
