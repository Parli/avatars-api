supertest = require('supertest')
webserver = require('../lib/webserver')
expect    = require('chai').expect
im        = require('gm').subClass(imageMagick: true)

parseImage = (res, callback) ->
  res.setEncoding('binary')
  res.data = ''
  res.on 'data', (chunk) -> res.data += chunk
  res.on 'end', -> callback(null, new Buffer(res.data, 'binary'))

describe 'routing', ->
  request = null

  beforeEach ->
    request = supertest(webserver)

  # describe 'root', ->
  #   it 'redirects to the one-pager', (done) ->
  #     request.get('/')
  #       .expect(302)
  #       .expect('location', 'http://avatars.adorable.io')
  #       .end(done)

  describe 'v1 avatar request', ->
    it 'responds with an image', (done) ->
      request.get('/avatar/abott')
        .expect('Content-Type', /image/)
        .end(done)

    it 'can resize an image', (done) ->
      request.get('/avatar/230/abott')
        .parse(parseImage)
        .end (err, res) ->
          im(res.body).size (err, size) ->
            expect(size).to.eql(height: 230, width: 230)
            done()

  describe 'v2 avatar request', ->
    it 'responds with an image', (done) ->
      request.get('/avatars/abott')
        .expect('Content-Type', /image/)
        .end(done)

    it 'can resize an image', (done) ->
      request.get('/avatars/220/abott')
        .parse(parseImage)
        .end (err, res) ->
          im(res.body).size (err, size) ->
            expect(size).to.eql(height: 220, width: 220)
            done()

    it 'can manually compose an image', (done) ->
      request.get('/avatars/face/eyes1/nose4/mouth11/bbb')
        .expect(200)
        .expect('Content-Type', /image/)
        .end(done)

  describe 'v2 avatar list requests', ->
    it 'responds with json', (done) ->
      request.get('/avatars/list')
        .expect('Content-Type', /json/)
        .end(done)

    it 'responds with a list of possible face parts', (done) ->
      request.get('/avatars/list')
        .end (err, res) ->
          faceParts = res.body.face
          expect(faceParts).to.have.keys('eyes', 'mouth', 'nose')
          done()
