router = require('express').Router()
common = require('./common.coffee')
Identicon = require('identicon.js')

router.param 'id', (req, res, next, id) ->
  identicon = new Identicon(id.replace('-',''), 400).toString()
  req.identicon = new Buffer(identicon, 'base64')
  next()

router.get '/:id', (req, res, next) ->
  res.writeHead 200,
    'Content-Type'  : 'image/png'
    'Content-Length': req.identicon.length
  res.end req.identicon

module.exports = router
