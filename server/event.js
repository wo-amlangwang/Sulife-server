module.exports = function(socket,io){
  socket.on('SomeEvent',function(data){
    socket.broadcast.emit('ping');
  });
}
