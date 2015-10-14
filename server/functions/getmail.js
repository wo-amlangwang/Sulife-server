var Mailbox = require('../mongo_modules/mailbox.js');
var make = require('../middlewares/maketoken.js');
module.exports = {
  getmail : function(socket,data) {
    if(data.token === undefined){
      socket.emit('getmail',{'status' : 400,
                             'requestID' : data.id,
                             'message' : 'need token'});
    }else {
      make.checkToken(data.token).then(function(decoded) {
        Mailbox.find({'taker' : decoded.id},function(err,mails) {
          if(err){
            socket.emit('getmail',{'status' : 300,
                                   'requestID' : data.id,
                                   'message' : err});
          }else {
            socket.emit('getmail',{'status' : 100,
                                   'requestID' : data.id,
                                   'message' : mails});
          }
        });
      }).catch(function(err) {
        socket.emit('getmail',{'status' : 400,
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
}
*/
