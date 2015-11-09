var makeToken = require('./maketoken.js');
var thisPostEvent = require('./postEvent.js').postEvent;
var thisdeleteEvent = require('./deleteEvent.js').deleteEvent;
var thisgetEvent = require('./getEvent.js').getEvent;
var thiseditEvent = require('./editEvent.js').editEvent;
var thisgetAllEvent = require('./getAllEvent.js').getAllEvent;
var thischeckmailbox = require('./checkmailbox.js').checkmailbox;
var thisgetProfile = require('./getProfile.js').getProfile;
var thiseditProfile = require('./editProfile.js').editProfile;
var thischeckEventid = require('./checkEventid.js').checkEventid;
var thisfriendRequest = require('./friendRequest.js').friendRequest;
var thisgetMail = require('./getMail.js').getMail;
var thisacceptFriendRequest = require('./acceptFriendRequest.js').acceptFriendRequest;
var thisrejectFriendRequest = require('./rejectFriendRequest.js').rejectFriendRequest;
var thisbuildFriendRelationship = require('./buildFriendRelationship.js').buildFriendRelationship;
var thisgetFriends = require('./getFriends.js').getFriends;
var thisfindUser = require('./findUser.js').findUser;
var getEventByDate = require('./getAllEvent.js').getEventByDate;

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
  checkmailbox : thischeckmailbox,
  getProfile : thisgetProfile,
  editProfile : thiseditProfile,
  checkEventid : thischeckEventid,
  friendRequest : thisfriendRequest,
  getMail : thisgetMail,
  acceptFriendRequest : thisacceptFriendRequest,
  rejectFriendRequest : thisrejectFriendRequest,
  buildFriendRelationship : thisbuildFriendRelationship,
  getFriends : thisgetFriends,
  findUser : thisfindUser,
  getEventByDate : getEventByDate
}
