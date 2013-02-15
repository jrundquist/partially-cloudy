cloud   = require('../').HighCloud
should  = require('should')

describe 'HighCloud (server-side)', () ->

  describe 'instance', () =>

    it 'should exit', () =>
      should.exist new cloud()

    it 'should initalize with default values', () =>
      pCloud = new cloud()
      # Port
      should.exist pCloud.port
      pCloud.port.should.equal 6379 #default

      #Hostname
      should.exist pCloud.hostname
      pCloud.hostname.should.equal '127.0.0.1'

      #Connection
      should.exist pCloud.conn

    it 'should be configurable [port,hostname]', () =>
      newCloud = new cloud 12345, '127.1.1.1'

      # Port
      should.exist newCloud.port
      newCloud.port.should.equal 12345

      #Hostname
      should.exist newCloud.hostname
      newCloud.hostname.should.equal '127.1.1.1'

      #Connection
      should.exist newCloud.conn

    it 'should be configurable [url]', () =>
      newCloud = new cloud 'redis://127.0.0.1:6379'

      # Port
      should.exist newCloud.port
      newCloud.port.should.equal 6379

      #Hostname
      should.exist newCloud.hostname
      newCloud.hostname.should.equal '127.0.0.1'

      #Connection
      should.exist newCloud.conn



  describe 'connection', () =>
    pCloud = new cloud()
    it 'should be connected to localhost', () =>
      pCloud.conn.connected.should.be.ok
    it 'should set "test" to 52', () =>
      pCloud.set "test", '52'
    it 'should get "test" as 52', (done) =>
      pCloud.get "test", (err, res) ->
        res.should.equal '52'
        done()


