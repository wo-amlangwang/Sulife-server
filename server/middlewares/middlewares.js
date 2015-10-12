var makeToken = require('./maketoken.js');
var thisPostEvent = require('./postEvent.js').postEvent;
var thisdeleteEvent = require('./deleteEvent.js').deleteEvent;

module.exports = {
  verifyToken : function(req,res,next) {
    if(req.headers['x-access-token'] === undefined){
      res.status(403).send({"message" : "need Token"});
    }else {
      makeToken.checkToken(req.body.token).then(function(result) {
        req.userid = result.id;
        return next();
      }).catch(function(err) {
        res.status(403).send({"message" : "bad token"});
      });
    }
  },
  postEvent : thisPostEvent,
  deleteEvent : thisdeleteEvent

}
