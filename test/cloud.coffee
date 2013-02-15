partiallyCloudy   = require '../'
http              = require 'http'
should            = require 'should'
request           = require 'request'
ioClient          = require 'socket.io-client'



# creates a socket.io client for the given server
client = (srv, nsp, opts) ->
  if typeof nsp is 'object'
    opts = nsp
    nsp = null
  addr = srv.address()
  if !addr
    addr = srv.listen().address()
  url = 'ws://' + addr.address + ':' + addr.port + (nsp || '')
  return ioClient.connect(url, opts)





describe 'Cloud (server)', () ->
  before () =>
    @port = 8080
    @cloud = partiallyCloudy.Cloud

  describe 'instance', () =>

    it 'should exit', () =>
      should.exist @cloud

    it 'should not duplicate', () =>
      @cloud.should.equal require('../').Cloud


  describe 'listen', () =>
    it 'should have a "listen()" method', () =>
      should.exist @cloud.listen

    it 'should accept a svr to listen on', (done) =>
      @cloud.listen(http.createServer().listen(@port))
      request "http://localhost:#{@port}/socket.io/socket.io.js", (err, res, body) ->
        res.statusCode.should.equal 200
        done()

    it 'should accept port to listen on', (done) =>
      @cloud.listen(@port)
      request "http://localhost:#{@port}/socket.io/socket.io.js", (err, res, body) ->
        res.statusCode.should.equal 200
        done()





  describe 'io-connection', () =>

    it 'should be connectable', (done) =>
      @cloud.listen(@port)
      socket = client @cloud.io.server
      @cloud.io.on 'connection', (socket) ->
        done()

    it 'socket should get connect event', (done) =>
      @cloud.listen(@port)
      socket = client @cloud.io.server
      socket.on 'connect', ->
        done()



