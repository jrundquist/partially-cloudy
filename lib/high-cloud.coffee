url    = require 'url'
redis  = require 'redis'
events = require 'events'


class HighCloud extends events.EventEmitter
  constructor: (port, hostname) ->
    @port = port
    @hostname = hostname

    if typeof port is "undefined"
      [@port, @hostname] = [6379, '127.0.0.1']
    else if typeof hostname is "undefined"
      info = url.parse port
      [@port, @hostname] = [parseInt(info.port, 10), info.hostname]

    @conn = redis.createClient @port, @hostname

  set: =>
    @conn.set.apply @conn, arguments

  get: =>
    @conn.get.apply @conn, arguments


# Export the main object
exports = module.exports = HighCloud