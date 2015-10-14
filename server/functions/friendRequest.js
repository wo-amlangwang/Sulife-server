var Mailbox = require('../mongo_modules/mailbox.js');
var make = require('../middlewares/maketoken.js');
var ping = require('./ping.js').ping;

module.exports = {
  friendRequest :function(socket,data) {
    if(data.token === undefined){
      socket.emit('friendRequest',{'status' : 400,
                                   'requestID' : data.id,
                                   'message' : 'need token'});
    }else {
      make.checkToken(data.token).then(function(decoded) {
        NewMail = new Mailbox();
        NewMail.sender = decoded.id;
        NewMail.taker = data.target;
        NewMail.issuenumber = 100;
        NewMail.issuedetail = 'A friend request';
        NewMail.send = false;
        NewMail.save(function(err) {
          if(err){
            //handle err TODO
          }else {
            ping(socket);
          }
        });
      }).catch(function(err) {
        socket.emit('friendRequest',{'status' : 400,
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
target : target's userid
}
*/
