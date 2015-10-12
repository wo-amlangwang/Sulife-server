var makeToken = require('./makeToken.js');
var thisPostEvent = require('./postEvent.js').postEvent;
var thisdeleteEvent = require('./deleteEvent.js').deleteEvent;

module.exports = {
  verifyToken : function(req,res,next) {
    if(res.token === undefined){
      res.status(403).send({"message" : "need Token"});
    }else {
      makeToken.verifyToken(req.token).then(function(result) {
        req.userid = result.id;
        return next();
      }).catch(function(err) {
        res.status(403).send({"message" : "bad token"});
      });
    }
  },
  postEvent : thisPostEvent,
  delete : thisdeleteEvent

}
