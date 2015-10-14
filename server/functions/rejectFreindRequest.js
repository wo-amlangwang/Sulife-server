var Mailbox = require('../mongo_modules/mailbox.js');
var make = require('../middlewares/maketoken.js');

module.exports = {
  rejectFriendRequest : function(socket,data) {
    if(data.token === undefined){
      socket.emit('rejectFriendRequest',{'status' : 400,
                                         'requestID' : data.id,
                                         'message' : 'need token'});
    }else {
      make.checkToken(data.token).then(function(decoded) {
        Mailbox.findOne({'_id' : data.mailid},function(err,mail) {
          if(err){
            socket.emit('rejectFriendRequest',{'status' : 300,
                                               'requestID' : data.id,
                                               'message' : err});
          }else {
            if(!mail.solved){
              if(mail.taker != decoded.id){
                socket.emit('rejectFriendRequest',{'status' : 500,
                                                   'requestID' : data.id,
                                                   'message' : 'forbidden'});
              }else {
                mail.solved = true;
                mail.save(function(err) {
                  if(err){
                    socket.emit('rejectFriendRequest',{'status' : 300,
                                                       'requestID' : data.id,
                                                       'message' : err});
                  }else {
                    socket.emit('rejectFriendRequest',{'status' : 100,
                                                       'requestID' : data.id,
                                                       'message' : 'ok'});
                  }
                });
              }
            }else {
              socket.emit('rejectFriendRequest',{'status' : 600,
                                                 'requestID' : data.id,
                                                 'message' : 'the event is sovled'});
            }
          }
        });
      }).catch(function(err) {
        socket.emit('rejectFriendRequest',{'status' : 400,
                                           'requestID' : data.id,
                                           'message' : err});
      });
    }
  }
}
/*
data formate
{
id : uuid
token : access_token
mailid : target mail to reject
}
*/
