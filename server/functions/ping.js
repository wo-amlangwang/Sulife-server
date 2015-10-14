module.exports = {
  ping : function(socket) {
    socket.broadcast.emit('ping');
  }
}
