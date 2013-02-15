# partially-cloudy
__Probabilistic Cloud Storage.__

## What is it?
Have you ever found yourself needing a real-time data store connection to your server that's stability is predicated upon the weather conditions of your users?

> probably not?

Well, partially-cloudy is exactly that.

partially-cloudy uses your local user's current cloud-cover information to determine the probability of success for write events. Read events will always succeed (assuming the data was written). The module uses a partially wrapped socket.io server to facilitate the real-time communication between client and server. Currently the back-end side of things uses a redis-store for the true storage engine.

## Install
```
npm install
```

## Usage

__Server Side__
```coffee
partiallyCloudy  =  require 'partially-cloudy'
sky              =  partiallyCloudy.Cloud
sky.listen(app)
```
This will attach the `sky` server to the HTTP server presumably with the rest of your app.

__Client Side__
```coffee
io = io.connect()
io.emit 'set', hash: 'something', data: 'important information'
io.emit 'get', 'something-else'
io.on 'update', (d) ->
  hash = d.hash
  data = d.data
```
This will soon be abstracted into a nice interface at some time down the line.


## Testing
```
make test
```

