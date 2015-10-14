var makeToken = require('./maketoken.js');
var thisPostEvent = require('./postEvent.js').postEvent;
var thisdeleteEvent = require('./deleteEvent.js').deleteEvent;
var thisgetEvent = require('./getEvent.js').getEvent;
var thiseditEvent = require('./editEvent.js').editEvent;
var thisgetAllEvent = require('./getAllEvent.js').getAllEvent;
var thischeckmailbox = require('./checkmailbox.js').checkmailbox;

module.exports = {
  verifyToken : function(req,res,next) {
    if(req.headers['x-access-token'] === undefined){
      res.status(401).send({"message" : "need Token"});
    }else {
      makeToken.checkToken(req.headers['x-access-token']).then(function(result) {
        req.userid = result.id;
        req.reJson = {};
        return next();
      }).catch(function(err) {
        console.log(err);
        res.status(401).send({"message" : "bad token"});
      });
    }
  },
  postEvent : thisPostEvent,
  deleteEvent : thisdeleteEvent,
  getEvent : thisgetEvent,
  editEvent : thiseditEvent,
  getAllEvent : thisgetAllEvent,
  checkmailbox : thischeckmailbox
}
