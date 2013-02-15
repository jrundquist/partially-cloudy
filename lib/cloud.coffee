io   = require 'socket.io'
HighCloud = require './high-cloud'
request = require 'request'

defaultP = 0.5


class Cloud
  constructor: (port, host) ->
    @highcloud = new HighCloud port, host

  listen: (server, highcloud, callback) ->
    if typeof highcloud is 'function'
      callback = highcloud
      highcloud = null
    if typeof callback isnt 'function'
      callback = ()->return

    @close () =>
      @io = io.listen(server)
      @io.set('log level', 0);
      @io.sockets.on 'connection', (socket) =>

        socket.join 'sky'

        socket.ip = socket.handshake.address?.address || '128.61.94.183'
        if socket.ip is '127.0.0.1'
          socket.ip = '128.61.94.183'
        weatherURL = "http://free.worldweatheronline.com/feed/weather.ashx?q=#{socket.ip}&format=json&key=ca034bf523211154131402"
        request weatherURL, (err, res, body) ->
          weather = JSON.parse(body)
          socket.p = weather?.data?.current_condition?[0].cloudcover

        socket.on 'room', (room) =>
          console.log 'ROOM CHANGE:'
          socket.which_room = room
          socket.join room

        socket.on 'set', (data) =>
          return if not data.hash
          if Math.random() > (socket.p || defaultP)
            @io?.sockets.in(socket.which_room).emit 'update', data
            @highcloud.set data.hash, data.data

        socket.on 'get', (hash) =>
          @highcloud.get hash, (err, res) =>
            return if err
            @io.sockets.in(socket.which_room).emit 'update', hash: hash, data: res
      callback()

  close: (callback=(()->)) ->
    if @io?.server?.close
      @io.server.close(callback)
    else
      callback()



# Export the main object
exports = module.exports = new Cloud()