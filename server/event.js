var make = require('./middlewares/makeToken.js');
var Mail = require('./mongo_modules/mailbox.js');
var Friend = require('./mongo_modules/friendlist.js');
module.exports = function(socket,io){
  socket.on('friendRequest',function(data){
    make.checkToken(data.token).then(function(decoded) {

    }).catch(function(err) {
      socket.emit('friendRequest', {'status' : 400,
                                    'message' : 'reject'});
    });
  });

  socket.on('getmail',function(data) {

  });

  socket.on('acceptFriendRequest', function(data) {

  });

  socket.on('rejectFriendRequest',function(data) {

  });

  function ping() {
      socket.broadcast.emit('ping');
  }
}
