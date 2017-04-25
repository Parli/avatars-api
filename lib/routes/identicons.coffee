Identicon = require('identicon.js')
md5 = require('md5')
router = require('express').Router()
common = require('./common.coffee')

router.param 'id', (req, res, next, id) ->
  identicon = new Identicon(md5(id), 400).toString()
  req.identicon = new Buffer(identicon, 'base64')
  next()

router.get '/:id', (req, res, next) ->
  res.writeHead 200,
    'Content-Type'  : 'image/png'
    'Content-Length': req.identicon.length
  res.end req.identicon

module.exports = router
