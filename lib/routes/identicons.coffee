Identicon = require('identicon.js')
md5 = require('md5')
router = require('express').Router()
common = require('./common.coffee')
imageMagick = require('gm').subClass({imageMagick: true})

unfuck = (buffer, callback) ->
  imageMagick(buffer, 'identicon.png')
    .stream('png', callback)

router.param 'id', (req, res, next, id) ->
  identicon = new Identicon(md5(id), 400).toString()
  req.identicon = new Buffer(identicon, 'base64')
  next()

router.get '/:id', (req, res, next) ->
  unfuck req.identicon, (err, stdout) ->
    common.sendImage(err, stdout, req, res, next)

module.exports = router
