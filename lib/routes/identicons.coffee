router = require('express').Router()
common = require('./common.coffee')
Identicon = require('identicon.js')

router.param 'id', (req, res, next, id) ->
  req.identicon = new Identicon(id.replace('-',''), 400).toString()
  next()

router.get '/:id', (req, res, next) ->
  res.send '<img width=400 height=400 src="data:image/png;base64,' + req.identicon + '">'

module.exports = router
